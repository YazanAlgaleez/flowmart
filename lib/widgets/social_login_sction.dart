import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLoginSection extends StatelessWidget {
  final String mainText;
  final String promptText;
  final String buttonText;
  final VoidCallback onButtonPressed; // <-- سيستقبل دالة (function)

  const SocialLoginSection({
    super.key,
    required this.mainText,
    required this.promptText,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30.0),
        Text(
          mainText, // <-- صار باراميتر
          style: TextStyle(color: Colors.grey[600]),
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialButton(
              icon: FontAwesomeIcons.facebook,
              color: Color(0xFF1877F2),
              onPressed: () {},
            ),
            SizedBox(width: 20),
            SocialButton(
              icon: FontAwesomeIcons.google,
              color: Color(0xFFDB4437),
              onPressed: () {},
            ),
            SizedBox(width: 20),
            SocialButton(
              icon: FontAwesomeIcons.apple,
              color: Colors.black,
              onPressed: () {},
            ),
          ],
        ),
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              promptText, // <-- صار باراميتر
              style: TextStyle(color: Colors.grey[700]),
            ),
            TextButton(
              onPressed: onButtonPressed, // <-- صار باراميتر
              child: Text(
                buttonText, // <-- صار باراميتر
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// هذا الكلاس يبقى كما هو
class SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 60,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: FaIcon(icon, color: color, size: 28)),
      ),
    );
  }
}
