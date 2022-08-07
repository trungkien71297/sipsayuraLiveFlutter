import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color gray400 = fromHex('#c4c4c4');

  static Color gray500 = fromHex('#929292');

  static Color black9002b = fromHex('#2b000000');

  static Color lightBlue700 = fromHex('#1690c4');

  static Color gray700Null = fromHex('#5c5c5c');

  static Color lightBlue700C9 = fromHex('#c91690c5');

  static Color gray300 = fromHex('#e6e6e6');

  static Color gray50 = fromHex('#fafafa');

  static Color bluegray900 = fromHex('#333333');

  static Color bluegray800 = fromHex('#444053');

  static Color black900 = fromHex('#000000');

  static Color black90028 = fromHex('#28000000');

  static Color whiteA701 = fromHex('#fffcfc');

  static Color whiteA700 = fromHex('#ffffff');

  static Color lightBlue700Bf = fromHex('#bf1690c4');

  static Color red900 = fromHex('#c41616');

  static Color black9007f = fromHex('#7f000000');

  static Color black900Null = fromHex('#000000');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
