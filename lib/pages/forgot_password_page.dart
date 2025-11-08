import 'package:flowmart/core/styling/app_styles.dart';
import 'package:flowmart/core/widgets/primary_button_widget.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 50.0)),
          Text("Forgot Password?", style: AppStyles.primaryHeadLineStyle),
          Padding(padding: EdgeInsets.only(top: 20.0)),
          Text(
            "Don't worry! itc occurs, Please enter the email address linked with you account.  ",
            style: AppStyles.supTitleStyle,
          ),
          Padding(padding: EdgeInsets.only(top: 20.0)),
          TextField(
            decoration: InputDecoration(
              hintText: "Enter Your Email",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          Padding(padding: EdgeInsets.only(top: 20.0)),
          PrimaryButtonWidget(
            buttonText: "Send Code",
            onPressed: () {
              // Handle reset link logic here
              print("Reset link sent");
            },
          ),
        ],
      ),
    );
  }
}
