import 'package:flowmart/core/styling/app_styles.dart';
import 'package:flowmart/core/widgets/primary_textfield_widget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 50.0)),
          Text(
            "Welcome back!              Again",
            style: AppStyles.primaryHeadLineStyle,
          ),
          Padding(padding: EdgeInsets.only(top: 20.0)),
          PrimaryTextfieldWidget(
            hintText: "Enter Your Email",
            keyboardType: TextInputType.emailAddress,
          ),
          Padding(padding: EdgeInsets.only(top: 20.0)),
          PrimaryTextfieldWidget(
            hintText: "Enter Your Password",
            keyboardType: TextInputType.visiblePassword,
          ),
        ],
      ),
    );
  }
}
