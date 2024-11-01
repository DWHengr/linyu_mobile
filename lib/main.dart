import 'package:flutter/material.dart';
import 'package:linyu_mobile/pages/navigation/index.dart';
import 'package:linyu_mobile/pages/login/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('x-token');
  runApp(MyApp(
      initialPage: token != null
          ? const CustomBottomNavigationBar()
          : LoginPage()));
}

class MyApp extends StatelessWidget {
  final Widget initialPage;

  const MyApp({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '林语',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4C9BFF),
          surface: const Color(0xFFFFFFFF),
          onSurface: Colors.black,
          primary: const Color(0xFF4C9BFF),
          onPrimary: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: initialPage,
    );
  }
}
