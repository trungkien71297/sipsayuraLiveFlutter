import 'dart:convert';

import 'package:crypto/crypto.dart';

class Conver {
  static String convertToSHA256Base64(String input) {
    // Convert string to bytes
    var bytes = utf8.encode(input);

    // Generate SHA-256 hash
    var digest = sha256.convert(bytes);

    // Convert hash to base64
    return base64Encode(digest.bytes);
  }
}
