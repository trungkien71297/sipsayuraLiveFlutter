import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';
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
  final Map<String, dynamic>? connectionInit;
  final uuid = Uuid();
  final bool needInit;
  final String? protocol;
  IOWebSocketChannel? channel;
  // Subscription management
  // final Map<String, StreamController<dynamic>> _subscriptions = {};

  // Callbacks
  late OnOpenCallback onOpen;
  late OnMessageCallback onMessage;
  late OnCloseCallback onClose;
  bool closed = false;

  GraphQLWebSocket(this._url,
      {this.connectionInit,
      String? cookie,
      Map<String, dynamic>? connectionParams,
      this.needInit = true,
      this.protocol})
      : _cookie = cookie;

  void _handleMessage(dynamic rawMessage) {
    try {
      final message = json.decode(rawMessage);
      final String? type = message['type'];
      if (type == null) return;
      switch (type) {
        case GraphQLWSMessageType.CONNECTION_ACK:
          break;

        case GraphQLWSMessageType.NEXT:
          break;

        case GraphQLWSMessageType.ERROR:
          break;

        case GraphQLWSMessageType.COMPLETE:
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

  // Stream<dynamic> subscribe(
  //   String query, {
  //   Map<String, dynamic>? variables,
  //   String? operationName,
  // }) {
  //   final String id = (_nextOperationId++).toString();
  //   // final controller = StreamController<dynamic>.broadcast();
  //   // _subscriptions[id] = controller;

  //   final Map<String, dynamic> payload = {
  //     'query': query,
  //   };

  //   if (variables != null) {
  //     payload['variables'] = variables;
  //   }

  //   if (operationName != null) {
  //     payload['operationName'] = operationName;
  //   }

  //   final message = {
  //     'type': GraphQLWSMessageType.SUBSCRIBE,
  //     'id': id,
  //     'payload': payload,
  //   };

  //   sendMessage(message);

  //   // Clean up when the stream is canceled
  //   // controller.onCancel = () {
  //   //   unsubscribe(id);
  //   // };

  //   // return controller.stream;
  // }

  void unsubscribe(String id) {
    sendMessage({
      'type': GraphQLWSMessageType.COMPLETE,
      'id': id,
    });
    // if (_subscriptions.containsKey(id)) {
    //   sendMessage({
    //     'type': GraphQLWSMessageType.COMPLETE,
    //     'id': id,
    //   });

    // _subscriptions[id]!.close();
    // _subscriptions.remove(id);
    // }
  }

  // void _cleanupSubscriptions() {
  //   for (final subscription in _subscriptions.values) {
  //     subscription.close();
  //   }
  //   _subscriptions.clear();
  // }

  void sendMessage(Map<String, dynamic> message) {
    if (!closed) {
      // Log.verbose('Send data $message');
      channel?.sink.add(json.encode(message));
    }
  }

  static String getJSESSIONID(String cookie) {
    final list = cookie.split(';');
    for (var l in list) {
      if (l.contains('JSESSIONID')) {
        final keyValue = l.split('=');
        return keyValue[1].trim();
      }
    }
    return '';
  }

  String subscribe({String? id, Map<String, dynamic>? payload}) {
    final data = {
      'type': GraphQLWSMessageType.SUBSCRIBE,
      'id': id ?? uuid.v4(),
      'payload': payload,
    };
    sendMessage(data);
    return data['id'] as String;
  }

  void connectWebSocket() async {
    // Creating the WebSocket connection with required headers
    final headers = {
      'Upgrade': 'websocket',
      'Connection': 'Upgrade',
      "Cookie": _cookie ?? '',
      // You might need to set other headers as needed
    };
    if (protocol != null) {
      headers.addAll({'Sec-WebSocket-Protocol': protocol!});
    }
    channel = IOWebSocketChannel.connect(
      _url,
      headers: headers,
    );

    // Listen for messages from the server
    channel!.stream.listen(
      (data) {
        // Pass the raw message to the callback
        _handleMessage(data);
        onMessage(data);
        // Also handle the message internally
      },
      onDone: () {
        onClose(channel?.closeCode, channel?.closeReason);
        // _cleanupSubscriptions();
      },
      onError: (error) {
        onClose(500, error.toString());
        // _cleanupSubscriptions();
      },
    );
    await channel!.ready;

    // Send a message to the server (example for GraphQL subscription)
    if (needInit) {
      channel!.sink.add(json.encode({
        'type': GraphQLWSMessageType.CONNECTION_INIT,
        'payload': connectionInit,
      }));
    }
    onOpen();

    // When you're done with the connection
    // channel.sink.close();
  }

  Future disconnect() async {
    closed = true;
    await channel?.sink.close();
  }
}
