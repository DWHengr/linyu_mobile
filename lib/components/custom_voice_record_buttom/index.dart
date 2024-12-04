import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalThemeConfig.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:vibration/vibration.dart';

class CustomVoiceRecordButton extends StatefulWidget {
  final Function(String path, int time)? onFinish;

  const CustomVoiceRecordButton({super.key, this.onFinish});

  @override
  State<CustomVoiceRecordButton> createState() => _VoiceRecordButtonState();
}

class _VoiceRecordButtonState extends State<CustomVoiceRecordButton> {
  final Record _record = Record();
  bool _isRecording = false;
  bool _isCanceled = false;
  Offset _startPosition = Offset.zero;
  Offset _currentPosition = Offset.zero;
  late OverlayEntry _overlayEntry;
  String? _filePath;
  Timer? _timer;
  int _recordingSeconds = 0;
  List<double> _amplitudes = List.filled(20, 0.0);

  GlobalThemeConfig theme = Get.find<GlobalThemeConfig>();

  void startRecording() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50);
    }
    final directory = await getTemporaryDirectory();
    _filePath = '${directory.path}/voice.wav';
    await _record.start(
      path: _filePath,
      encoder: AudioEncoder.wav,
      bitRate: 128000,
      samplingRate: 44100,
    );
    _startTimer();
    _updateAmplitude();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_recordingSeconds >= 60) {
        _stopRecording(autoStop: true);
      } else {
        setState(() {
          _recordingSeconds++;
        });
      }
    });
  }

  Future<void> _updateAmplitude() async {
    while (_isRecording) {
      try {
        final amplitude = await _record.getAmplitude();
        // 将 dB 转换为 0-1 的值，并调整范围
        double normalizedAmplitude = 0.0;
        if (amplitude?.current != null) {
          // 调整 dB 范围
          normalizedAmplitude = (amplitude!.current + 50) / 50;
          normalizedAmplitude = normalizedAmplitude.clamp(0.0, 1.0);
        }
        setState(() {
          // 将现有的振幅值向左移动
          for (int i = 0; i < _amplitudes.length - 1; i++) {
            _amplitudes[i] = _amplitudes[i + 1];
          }
          // 在最右端添加新的振幅值
          _amplitudes[_amplitudes.length - 1] = normalizedAmplitude;
        });
      } catch (e) {
        print(e);
      }
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  void _stopRecording({bool autoStop = false}) async {
    _timer?.cancel();
    final filePath = await _record.stop();
    _overlayEntry.remove();
    if (!_isCanceled && !autoStop && filePath != null) {
      widget.onFinish?.call(filePath, _recordingSeconds);
    } else if (autoStop && filePath != null) {
      widget.onFinish?.call(filePath, _recordingSeconds);
    }
    if (_isCanceled) {
      widget.onFinish?.call('', 0);
    }
    setState(() {
      _isRecording = false;
      _recordingSeconds = 0;
      _amplitudes = List.filled(20, 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        startRecording();
        setState(() {
          _isRecording = true;
          _isCanceled = false;
          _startPosition = details.globalPosition;
          _currentPosition = _startPosition;
        });
        _showRecordDialog(context);
      },
      onLongPressMoveUpdate: (details) {
        setState(() {
          _currentPosition = details.globalPosition;
          if (_currentPosition.dy < _startPosition.dy - 50) {
            if (!_isCanceled) {
              _isCanceled = true;
              Vibration.vibrate(duration: 50);
            }
          } else {
            if (_isCanceled) {
              _isCanceled = false;
            }
          }
        });
        _overlayEntry.markNeedsBuild();
      },
      onLongPressEnd: (details) {
        _stopRecording();
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "按住 说话",
            style: TextStyle(
              fontSize: 14,
              color: theme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _showRecordDialog(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        right: 0,
        bottom: 100,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 200,
              height: 160,
              decoration: BoxDecoration(
                color: _isCanceled
                    ? theme.errorColor.withOpacity(0.9)
                    : Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isCanceled ? Icons.delete : Icons.mic,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(20, (index) {
                        double height =
                            _isRecording ? 5 + (_amplitudes[index] * 10) : 5;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 50),
                            width: 3,
                            height: height,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _isCanceled ? "松开手指，取消发送" : "上滑取消，松开发送",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${_recordingSeconds}s",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry);
  }
}
