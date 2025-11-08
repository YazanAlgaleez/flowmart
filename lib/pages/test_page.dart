import 'package:flowmart/core/widgets/appbar_widget.dart';
import 'package:flowmart/core/widgets/primary_button_widget.dart';
import 'package:flowmart/core/widgets/primary_outline_button_widgets.dart';
import 'package:flowmart/core/widgets/primary_textfield_widget.dart';
import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppbarWidget(),
      ),

      body: Center(
        child: Column(
          children: [
            PrimaryButtonWidget(buttonText: "text app"),
            Padding(padding: const EdgeInsets.all(16.0)),

            PrimaryTextfieldWidget(),
            PrimaryOutlineButtonWidgets(),
          ],
        ),
      ),
    );
  }
}
