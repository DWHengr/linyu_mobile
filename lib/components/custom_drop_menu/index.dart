import 'package:flutter/material.dart';

class DropMenuWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data; //数据
  final Function(String value) selectCallBack; //选中之后回调函数
  final String? selectedValue; //默认选中的值
  final Widget? leading; //前面的widget，一般是title
  final Widget trailing; //尾部widget，一般是自定义图片
  final Color? textColor;
  final Offset offset; //下拉框向下偏移量--手动调整间距---防止下拉框遮盖住显示的widget
  final TextStyle normalTextStyle; //下拉框的文字样式
  final TextStyle selectTextStyle; //下拉框选中的文字样式
  final double maxHeight; //下拉框的最大高度
  final double maxWidth; //下拉框的最大宽度
  final Color? backGroundColor; //下拉框背景颜色
  final bool animation; //是否显示动画---尾部图片动画
  final int duration; //动画时长
  const DropMenuWidget({
    super.key,
    this.leading,
    required this.data,
    required this.selectCallBack,
    this.selectedValue,
    this.trailing = const Icon(Icons.arrow_drop_down),
    this.textColor = Colors.white,
    this.offset = const Offset(0, 30),
    this.normalTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 12.0,
    ),
    this.selectTextStyle = const TextStyle(
      color: Colors.red,
      fontSize: 12.0,
    ),
    this.maxHeight = 200.0,
    this.maxWidth = 200.0,
    this.backGroundColor = const Color.fromRGBO(28, 34, 47, 1),
    this.animation = true,
    this.duration = 200,
  });

  @override
  State<DropMenuWidget> createState() => _DropMenuWidgetState();
}

class _DropMenuWidgetState extends State<DropMenuWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  String _selectedLabel = '';
  String _currentValue = '';

  // 是否展开下拉按钮
  bool _isExpand = false;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.selectedValue ?? '';

    print('当前选中的值：${widget.selectedValue}');

    if (widget.animation) {
      _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.duration),
      );
      _animation = Tween(begin: 0.0, end: 0.5).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _toggleExpand() {
    setState(() {
      if (_isExpand) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  //根据传值处理显示的文字
  _initLabel() {
    if (_currentValue.isNotEmpty) {
      _selectedLabel = widget.data
          .firstWhere((item) => item['value'] == _currentValue)['label'];
    } else if (widget.data.isNotEmpty) {
      // 没值默认取第一个
      _selectedLabel = widget.data[0]['label'];
      _currentValue = widget.data[0]['value'];
    }
  }

  @override
  Widget build(BuildContext context) {
    _initLabel();
    return PopupMenuButton(
      constraints: BoxConstraints(
        maxHeight: widget.maxHeight,
        maxWidth: widget.maxWidth,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      offset: widget.offset,
      color: widget.backGroundColor,
      onOpened: () {
        if (widget.animation) {
          setState(() {
            _isExpand = true;
            _toggleExpand();
          });
        }
      },
      onCanceled: () {
        if (widget.animation) {
          setState(() {
            _isExpand = false;
            _toggleExpand();
          });
        }
      },
      child: Container(
        alignment: Alignment.centerLeft,
        height: 40,
        child: FittedBox(
          //使用FittedBox是为了适配当字符串长度超过指定宽度的时候，会让字体自动缩小
          child: Row(
            children: [
              if (widget.leading != null) widget.leading!,
              Text(
                _selectedLabel,
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: 14.0,
                ),
              ),
              if (widget.animation)
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _animation.value * 2.0 * 3.14, // 180度对应的弧度值
                      child: widget.trailing,
                    );
                  },
                ),
              if (!widget.animation) widget.trailing,
            ],
          ),
        ),
      ),
      itemBuilder: (context) {
        return widget.data.map((e) {
          return PopupMenuItem(
            child: Text(
              e['label'],
              style: e['value'] == _currentValue
                  ? widget.selectTextStyle
                  : widget.normalTextStyle,
            ),
            onTap: () {
              setState(() {
                _currentValue = e['value'];
                widget.selectCallBack(e['value']);
              });
            },
          );
        }).toList();
      },
    );
  }
}
