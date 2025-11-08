import 'package:flowmart/core/styling/app_styles.dart';
import 'package:flowmart/core/widgets/primary_button_widget.dart';
import 'package:flowmart/core/widgets/primary_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 50.0)),
          Text(
            "Hello ! Register to get             started",
            style: AppStyles.primaryHeadLineStyle,
          ),
          Padding(padding: EdgeInsets.only(top: 12.0.h)),
          PrimaryTextfieldWidget(
            hintText: "Username",
            keyboardType: TextInputType.name,
          ),
          Padding(padding: EdgeInsets.only(top: 12.0.h)),
          PrimaryTextfieldWidget(
            hintText: "Email",
            keyboardType: TextInputType.emailAddress,
          ),
          Padding(padding: EdgeInsets.only(top: 12.0.h)),
          PrimaryTextfieldWidget(
            hintText: "Password",
            keyboardType: TextInputType.visiblePassword,
          ),
          Padding(padding: EdgeInsets.only(top: 12.0.h)),
          PrimaryTextfieldWidget(
            hintText: "Confirm Password",
            keyboardType: TextInputType.visiblePassword,
          ),
          Padding(padding: EdgeInsets.only(top: 30.0.h)),
          PrimaryButtonWidget(
            buttonText: "Register",
            onPressed: () {
              // Handle registration logic here
              print("Register button pressed");
            },
          ),
        ],
      ),
    );
  }
}
