import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';


Future<String?> pickImage() async {
  final picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
  return pickedFile?.path;
}

Future<String?> pickAudio() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.audio,
  );

  if (result != null) {
    return result.files.first.path;
  } else {
    return null;
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;

  const AudioPlayerWidget({super.key, required this.audioPath});

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

  void _play() async {
    await _audioPlayer.play(DeviceFileSource(widget.audioPath));
    setState(() {
      isPlaying = true;
    });
  }

  void _pause() async {
    await _audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  void _stop() async {
    await _audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  void _increaseVolume() {
    if (currentVolume < 1.0) {
      currentVolume += 0.1;
      _audioPlayer.setVolume(currentVolume);
    }
  }

  void _decreaseVolume() {
    if (currentVolume > 0.0) {
      currentVolume -= 0.1;
      _audioPlayer.setVolume(currentVolume);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Audio: ${widget.audioPath.split('/').last}'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: _play,
              tooltip: 'Play',
            ),
            IconButton(
              icon: const Icon(Icons.pause),
              onPressed: _pause,
              tooltip: 'Pause',
            ),
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: _stop,
              tooltip: 'Stop',
            ),
            IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: _increaseVolume,
              tooltip: 'Volume Up',
            ),
            IconButton(
              icon: const Icon(Icons.volume_down),
              onPressed: _decreaseVolume,
              tooltip: 'Volume Down',
            ),
          ],
        ),
      ],
    );
  }
}