import 'package:flowmart/core/widgets/primary_button_widget.dart';
import 'package:flowmart/core/widgets/primary_outline_button_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnbordarPage extends StatelessWidget {
  const OnbordarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Welcome Page'),
      //   centerTitle: true,
      //   backgroundColor: Colors.blue,
      // ),
      body: Column(
        children: [
          Center(
            child: Image.asset(
              "lib/assets/images/WhatsApp Image 2025-10-31 at 16.23.33_375c0630.jpg",
              width: 375.w,
              height: 580.h,
              fit: BoxFit.cover,
            ),
          ),
          Padding(padding: const EdgeInsets.only(bottom: 20.0)),
          PrimaryButtonWidget(buttonText: "Login"),
          Padding(padding: const EdgeInsets.only(bottom: 16.0)),
          PrimaryOutlineButtonWidgets(buttonText: "Register"),
        ],
      ),
    );
  }
}
