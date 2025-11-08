import 'package:flowmart/core/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(),
      body: Container(
        child: Expanded(
          child: Image.asset(
            'lib/assets/images/download.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
