import 'package:flowmart/core/widgets/appbar_widget.dart';
import 'package:flowmart/core/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppbarWidget(title: "search"),
    );
  }
}
