import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/getx_config/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('x-token');
  // runApp(MyApp(
  //     initialPage:
  //         token != null ? const CustomBottomNavigationBar() : LoginPage()));
  runApp(MyApp(
      initialPage2:
          token != null ? '/' : '/login'));
}

class MyApp extends StatelessWidget {
  final String? initialPage2;
  final Widget? initialPage;

  const MyApp({super.key, this.initialPage,this.initialPage2});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '林语',
      //全局绑定Controller
      initialBinding: ControllerBinding(),
      enableLog: true,
      //路由配置
      getPages: pageRoute,
      //路由从右侧向左滑入（对GetX有效）
      defaultTransition: Transition.rightToLeft,
      initialRoute: initialPage2,
      //路由监听
      routingCallback: routingCallback,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4C9BFF),
          surface: const Color(0xFFFFFFFF),
          onSurface: Colors.black,
          primary: const Color(0xFF4C9BFF),
          onPrimary: Colors.white,
        ),
        splashColor: const Color(0x80EAEAEA),
        highlightColor: const Color(0x80EAEAEA),
        useMaterial3: true,
      ),
      // home: initialPage,
    );
  }
}
