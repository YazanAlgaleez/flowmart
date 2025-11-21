import 'package:flutter/material.dart';

class ColorReverseThameWitch {
  final bool isDark;
  final bool isGirlie;

  ColorReverseThameWitch({required this.isDark, required this.isGirlie});
  Color get color {
    return isDark
        ? Colors.white
        : isGirlie
        ? const Color(0xFF8B008B)
        : Colors.black;
  }
}
