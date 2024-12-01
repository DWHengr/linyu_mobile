import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:linyu_mobile/components/custom_sound_icon/index.dart';
import 'package:linyu_mobile/utils/getx_config/GlobalThemeConfig.dart';

class CustomAudio extends StatefulWidget {
  final String audioUrl;
  final int time;
  final String type;
  final VoidCallback? onLoadedMetadata;

  const CustomAudio({
    super.key,
    required this.audioUrl,
    required this.time,
    this.type = '',
    this.onLoadedMetadata,
  });

  @override
  State<CustomAudio> createState() => _CustomAudioWidgetState();
}

class _CustomAudioWidgetState extends State<CustomAudio> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  final GlobalThemeConfig _globalThemeConfig = Get.find<GlobalThemeConfig>();

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.playerStateStream.listen((playerState) async {
      if (playerState.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
        });
        await _audioPlayer.pause();
        _audioPlayer.seek(Duration.zero);
      }
    });

    _audioPlayer.durationStream.listen((duration) {
      widget.onLoadedMetadata?.call();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        setState(() {
          _isPlaying = false;
        });
      } else {
        setState(() {
          _isPlaying = true;
        });
        if (_audioPlayer.duration == null) {
          await _audioPlayer.setUrl(widget.audioUrl);
        }
        await _audioPlayer.play();
      }
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMinor = widget.type == 'minor';
    return GestureDetector(
      onTap: _playAudio,
      child: Container(
        decoration: BoxDecoration(
          color: isMinor ? Colors.white : _globalThemeConfig.primaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        width: 120,
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            CustomSoundIcon(
              isStart: _isPlaying,
              barColor: isMinor ? Colors.black : Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              '${widget.time}"',
              style: TextStyle(
                color: isMinor ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
