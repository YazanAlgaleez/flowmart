import 'package:flowmart/core/styling/app_colors.dart';
import 'package:flutter/material.dart';

class PrimaryTextfieldWidget extends StatelessWidget {
  final String? hintText;
  final TextInputType keyboardType;

  const PrimaryTextfieldWidget({
    super.key,
    this.hintText,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: 331,
      child: TextField(
        keyboardType: keyboardType,
        obscureText: keyboardType == TextInputType.visiblePassword,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.TextFieldColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black, width: 5.0),
          ),
          hintText: hintText ?? 'Enter text',
          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
        ),
        style: const TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }
}
