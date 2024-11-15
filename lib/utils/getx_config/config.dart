import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/utils/getx_config/route.dart';

typedef InitFunc = void Function();
typedef CloseFunc = void Function();
typedef CallbackFunc = void Function();
typedef FilterFunc<T> = Object Function(T value);

//路由配置
List<GetPage> pageRoute = AppRoutes.pageRoute;

//路由监听
void routingCallback(router) {
  debugPrint("enter>>>>>>>>>>>>>>>>${router.current}");
}

/// 通过内置GetBuilder来构建，配合GetView使用
/// 与业务逻辑绑定，通过GetX实现状态管理，这样页面只负责渲染，业务逻辑全部在控制器中实现
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
  void init(BuildContext context) => print("init>${controller.runtimeType}");

  /// 依赖发生变化
  void didChangeDependencies(BuildContext context) =>
      print("change>${controller.runtimeType}");

  /// 更新Widget
  void didUpdateWidget(
    GetBuilder oldWidget,
    GetBuilderState<T> state,
  ) =>
      print("update>${controller.runtimeType}");

  /// 构建widget
  Widget buildWidget(BuildContext context);

  /// 关闭
  void close(BuildContext context) => print("close>${controller.runtimeType}");

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
          return this.buildWidget(context);
        },
        dispose: (GetBuilderState<T> state) => this.close(context),
      );
}

/// 继承自GetView
/// 适用于局部
abstract class CustomWidgetObx<T extends GetxController> extends GetView<T> {
  const CustomWidgetObx({required Key key}) : super(key: key);

  dynamic get arguments => Get.arguments;

  Widget buildWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return buildWidget(context);
    });
    // return  buildWidget();
  }
}
