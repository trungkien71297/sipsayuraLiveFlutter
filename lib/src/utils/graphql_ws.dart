import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:uuid/uuid.dart';

import 'log.dart';

// Callbacks
typedef void OnMessageCallback(dynamic msg);
typedef void OnCloseCallback(int? code, String? reason);
typedef void OnOpenCallback();

// GraphQL WebSocket message types
class GraphQLWSMessageType {
  static const String CONNECTION_INIT = 'connection_init';
  static const String CONNECTION_ACK = 'connection_ack';
  static const String PING = 'ping';
  static const String PONG = 'pong';
  static const String SUBSCRIBE = 'subscribe';
  static const String NEXT = 'next';
  static const String ERROR = 'error';
  static const String COMPLETE = 'complete';
}

class GraphQLWebSocket {
  final String _url;
  final String? _cookie;
  final Map<String, String>? _additionalHeaders;
  final Map<String, dynamic>? _connectionParams;
  final Map<String, dynamic>? connectionInit;
  final uuid = Uuid();
  WebSocket? _socket;

  // Subscription management
  final Map<String, StreamController<dynamic>> _subscriptions = {};
  int _nextOperationId = 1;

  // Callbacks
  late OnOpenCallback onOpen;
  late OnMessageCallback onMessage;
  late OnCloseCallback onClose;

  GraphQLWebSocket(
    this._url, {
    this.connectionInit,
    String? cookie,
    Map<String, String>? additionalHeaders,
    Map<String, dynamic>? connectionParams,
  })  : _cookie = cookie,
        _additionalHeaders = additionalHeaders,
        _connectionParams = connectionParams;

  Future<void> connect() async {
    try {
      _socket = await _connectForSelfSignedCert(_url, cookie: _cookie);

      _socket!.listen(
        (data) {
          // Pass the raw message to the callback
          onMessage(data);

          // Also handle the message internally
          _handleMessage(data);
        },
        onDone: () {
          onClose(_socket!.closeCode, _socket!.closeReason);
          _cleanupSubscriptions();
        },
        onError: (error) {
          onClose(500, error.toString());
          _cleanupSubscriptions();
        },
      );

      // Initialize the connection
      _sendConnectionInit();

      // Notify that the connection is open
      onOpen();
    } catch (e) {
      onClose(500, e.toString());
    }
  }

  void _sendConnectionInit() {
    final message = {
      'type': GraphQLWSMessageType.CONNECTION_INIT,
      'payload': connectionInit,
    };

    sendMessage(message);
  }

  void _handleMessage(dynamic rawMessage) {
    try {
      final message = json.decode(rawMessage);
      final String type = message['type'];

      switch (type) {
        case GraphQLWSMessageType.CONNECTION_ACK:
          // Connection established successfully
          break;

        case GraphQLWSMessageType.NEXT:
          final String id = message['id'];
          final payload = message['payload'];
          if (_subscriptions.containsKey(id)) {
            _subscriptions[id]!.add(payload);
          }
          break;

        case GraphQLWSMessageType.ERROR:
          final String id = message['id'];
          final payload = message['payload'];
          if (_subscriptions.containsKey(id)) {
            _subscriptions[id]!.addError(payload);
          }
          break;

        case GraphQLWSMessageType.COMPLETE:
          final String id = message['id'];
          if (_subscriptions.containsKey(id)) {
            _subscriptions[id]!.close();
            _subscriptions.remove(id);
          }
          break;

        case GraphQLWSMessageType.PING:
          // Respond with pong
          sendMessage({
            'type': GraphQLWSMessageType.PONG,
            'payload': message['payload']
          });
          break;
      }
    } catch (e) {
      Log.verbose("Error handling message: $e");
    }
  }

  Stream<dynamic> subscribe(
    String query, {
    Map<String, dynamic>? variables,
    String? operationName,
  }) {
    final String id = (_nextOperationId++).toString();
    final controller = StreamController<dynamic>.broadcast();
    _subscriptions[id] = controller;

    final Map<String, dynamic> payload = {
      'query': query,
    };

    if (variables != null) {
      payload['variables'] = variables;
    }

    if (operationName != null) {
      payload['operationName'] = operationName;
    }

    final message = {
      'type': GraphQLWSMessageType.SUBSCRIBE,
      'id': id,
      'payload': payload,
    };

    sendMessage(message);

    // Clean up when the stream is canceled
    controller.onCancel = () {
      unsubscribe(id);
    };

    return controller.stream;
  }

  void unsubscribe(String id) {
    if (_subscriptions.containsKey(id)) {
      sendMessage({
        'type': GraphQLWSMessageType.COMPLETE,
        'id': id,
      });

      _subscriptions[id]!.close();
      _subscriptions.remove(id);
    }
  }

  void _cleanupSubscriptions() {
    for (final subscription in _subscriptions.values) {
      subscription.close();
    }
    _subscriptions.clear();
  }

  void sendMessage(Map<String, dynamic> message) {
    if (_socket != null && _socket!.readyState == WebSocket.open) {
      final String data = json.encode(message);
      _socket!.add(data);
      Log.verbose("Send message on websocket: '$data'");
    }
  }

  void send(dynamic data) {
    if (_socket != null) {
      _socket!.add(data);
      Log.verbose("Send message on websocket: '$data'");
    }
  }

  void close() {
    if (_socket != null) {
      _socket!.close(WebSocketStatus.normalClosure);
    }
  }

  void closeWithReason(int reason) {
    if (_socket != null) {
      _socket!.close(reason);
    }
  }

  Future<WebSocket> _connectForSelfSignedCert(
    String url, {
    String? cookie,
  }) async {
    try {
      Random r = Random();
      String key = base64.encode(List<int>.generate(16, (_) => r.nextInt(255)));
      HttpClient client = HttpClient(context: SecurityContext());
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        Log.debug(
            "GraphQLWebSocket: Allow self-signed certificate => $host:$port");
        return true;
      };

      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.add('Connection', 'Upgrade');
      request.headers.add('Upgrade', 'websocket');
      request.headers.add('Sec-WebSocket-Version', '13');
      request.headers.add('Sec-Fetch-Mode', 'websocket');
      request.headers.add('Sec-WebSocket-Protocol', 'graphql-transport-ws');
      request.headers.add('Sec-WebSocket-Key', key.toLowerCase());

      if (_additionalHeaders != null) {
        _additionalHeaders!.entries.forEach((e) {
          request.headers.add(e.key, e.value);
        });
      }

      if (cookie != null) {
        final finalCookie = getJSESSIONID(cookie);
        request.cookies.add(Cookie('JSESSIONID', finalCookie));
      }

      HttpClientResponse response = await request.close();
      Log.debug(
          'Connect ${response.statusCode} ${response.headers}\n Request \n ${request.headers}');

      Socket socket = await response.detachSocket();
      var webSocket = WebSocket.fromUpgradedSocket(
        socket,
        protocol: 'graphql-transport-ws',
        serverSide: false,
      );

      return webSocket;
    } catch (e) {
      throw e;
    }
  }

  String getJSESSIONID(String cookie) {
    final list = cookie.split(';');
    for (var l in list) {
      if (l.contains('JSESSIONID')) {
        final keyValue = l.split('=');
        return keyValue[1].trim();
      }
    }
    return '';
  }

  void subcribe({String? id, Map<String, dynamic>? payload}) {
    final data = {
      'type': GraphQLWSMessageType.SUBSCRIBE,
      'id': id ?? uuid.v4(),
      'payload': payload,
    };
    sendMessage(data);
  }
}
