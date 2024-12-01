import 'package:flutter/material.dart';

class CustomSoundIcon extends StatefulWidget {
  final bool isStart;
  final Color barColor;
  final double width;
  final double height;

  const CustomSoundIcon({
    super.key,
    this.isStart = false,
    this.barColor = Colors.black,
    this.width = 26,
    this.height = 16,
  });

  @override
  State<CustomSoundIcon> createState() => _SoundIconState();
}

class _SoundIconState extends State<CustomSoundIcon>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(5, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 1.5).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );
    }).toList();

    if (widget.isStart) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(CustomSoundIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isStart != oldWidget.isStart) {
      if (widget.isStart) {
        _startAnimation();
      } else {
        _stopAnimation();
      }
    }
  }

  void _startAnimation() {
    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(
          Duration(
              milliseconds: i == 0 || i == 4
                  ? 0
                  : i == 1 || i == 3
                      ? 250
                      : 500), () {
        _controllers[i].repeat(reverse: true);
      });
    }
  }

  void _stopAnimation() {
    for (var controller in _controllers) {
      controller.stop();
      controller.reset();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(5, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Container(
                width: 2,
                height: _getBarHeight(index) * _animations[index].value,
                color: widget.barColor,
              );
            },
          );
        }),
      ),
    );
  }

  double _getBarHeight(int index) {
    switch (index) {
      case 0:
      case 4:
        return 4.0;
      case 1:
      case 3:
        return 10.0;
      case 2:
        return 16.0;
      default:
        return 4.0;
    }
  }
}
