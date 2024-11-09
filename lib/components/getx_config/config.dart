import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/pages/register/logic.dart';
import 'package:pointycastle/asymmetric/api.dart';

import '../../api/user_api.dart';
import '../../pages/login/index.dart';
import '../../pages/login/logic.dart';
import '../../pages/navigation/index.dart';
import '../../pages/register/index.dart';
import '../../pages/retrieve_password/index.dart';
import '../../pages/retrieve_password/logic.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

typedef InitFunc = void Function();
typedef CloseFunc = void Function();
typedef CallbackFunc = void Function();
typedef FilterFunc<T> = Object Function(T value);

final _useApi = UserApi();

Future<String> passwordEncrypter(String password) async {
  final publicKeyResult = await _useApi.publicKey();
  if (publicKeyResult['code'] == 0) {
    String key = publicKeyResult['data'];
    final parsedKey = encrypt.RSAKeyParser().parse(key) as RSAPublicKey;
    final encrypter = encrypt.Encrypter(encrypt.RSA(publicKey: parsedKey));
    final encryptedPassword = encrypter.encrypt(password).base64;
    return encryptedPassword;
  }
  return "-1";
}

//依赖注入
class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginPageLogic());
    Get.lazyPut(() => RegisterPageLogic());
    Get.lazyPut(() => RetrievePasswordLogic());
  }
}

//路由配置
List<GetPage> pageRoute = [
  GetPage(name: '/', page: () => const CustomBottomNavigationBar()),
  GetPage(
    name: '/login',
    page: () => LoginPage(
      key: const Key('login'),
    ),
    binding: ControllerBinding(),
  ),
  GetPage(
    name: '/register',
    page: () => RegisterPage(
      key: const Key('register'),
    ),
    binding: ControllerBinding(),
  ),
  GetPage(
    name: '/retrieve_password',
    page: () => RetrievePassword(
      key: const Key('retrieve_password'),
    ),
    binding: ControllerBinding(),
  ),
];

//路由监听
void routingCallback(router) {
  debugPrint("enter>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${router.current}");
}

/// 通过内置GetBuilder来构建
/// 配合GetView使用
abstract class CustomWidget<T extends GetxController> extends StatelessWidget {
  /// 构造函数
  CustomWidget({this.key, this.widgetFilter}) : super(key: key);

  /// 当传入key的时候，若更新widget需使用controller.update([key],)
  @override
  final Key? key;

  /// 传入的参数
  final dynamic arguments = Get.arguments;

  /// 控制器的tag
  final String? tag = null;

  /// 获取控制器
  T get controller => GetInstance().find<T>(tag: tag);

  /// 过滤器
  // Object? widgetFilter(BuildContext context) => null;
  late final FilterFunc? widgetFilter;

  /// 初始化
  void init(BuildContext context) => debugPrint('\n初始化');

  /// 依赖发生变化
  void didChangeDependencies(BuildContext context) => debugPrint('\n依赖发生变化');

  /// 更新Widget
  void didUpdateWidget(
    GetBuilder oldWidget,
    GetBuilderState<T> state,
  ) =>
      debugPrint('\n更新Widget');

  /// 构建widget
  Widget buildWidget(BuildContext context);

  /// 关闭
  void close(BuildContext context) => debugPrint('\n关闭');

  /// 创建上下文
  @override
  StatelessElement createElement() => StatelessElement(this);

  /// 构建
  @override
  Widget build(BuildContext context) => GetBuilder<T>(
        id: this.key,
        filter: this.widgetFilter,
        initState: (GetBuilderState<T> state) => this.init(context),
        didChangeDependencies: (GetBuilderState<T> state) =>
            this.didChangeDependencies(context),
        didUpdateWidget: this.didUpdateWidget,
        builder: (controller) {
          debugPrint(
              "\n${context.widget.runtimeType.toString()}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>开始构建");
          return this.buildWidget(context);
        },
        dispose: (GetBuilderState<T> state) => this.close(context),
      );
}

/// 继承自GetView
/// 适用于局部
abstract class CustomWidget2<T extends GetxController> extends GetView<T> {
  const CustomWidget2({required Key key}) : super(key: key);

  dynamic get arguments => Get.arguments;

  Widget buildWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      debugPrint(
          "\n${context.widget.runtimeType.toString()}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>开始构建");
      return buildWidget(context);
    });
    // return  buildWidget();
  }
}
