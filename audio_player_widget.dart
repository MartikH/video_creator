import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:video_creator/styles/colors.dart';

import '../styles/text_styles.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;

  const AudioPlayerWidget({Key? key, required this.audioPath})
      : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  double currentVolume = 1.0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(DeviceFileSource(widget.audioPath));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  void _changeVolume(double delta) {
    setState(() {
      currentVolume = (currentVolume + delta).clamp(0.0, 1.0);
      _audioPlayer.setVolume(currentVolume);
    });
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    Color color = AppColors.secondary,
  }) {
    return IconButton(
      icon: Icon(icon),
      color: color,
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Audio: ${widget.audioPath.split('/').last}',
          textAlign: TextAlign.center,
          style: AppTextStyles.pathname,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIconButton(
              icon: isPlaying ? Icons.pause : Icons.play_arrow,
              onPressed: _togglePlayPause,
              tooltip: isPlaying ? 'Pause' : 'Play',
            ),
            _buildIconButton(
              icon: Icons.stop,
              onPressed: _stop,
              tooltip: 'Stop',
            ),
            _buildIconButton(
              icon: Icons.volume_up,
              onPressed: () => _changeVolume(0.1),
              tooltip: 'Volume Up',
            ),
            _buildIconButton(
              icon: Icons.volume_down,
              onPressed: () => _changeVolume(-0.1),
              tooltip: 'Volume Down',
            ),
          ],
        ),
      ],
    );
  }
}
