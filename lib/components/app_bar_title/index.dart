import 'package:flutter/cupertino.dart';

class AppBarTitle extends StatelessWidget {
  final String title;

  const AppBarTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: const TextStyle(fontSize: 20));
  }
}
