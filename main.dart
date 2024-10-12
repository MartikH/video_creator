import 'dart:io';

import 'package:file_picker/file_picker.dart'; // Для выбора папки
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'image_audio_picker.dart';
import 'video_creator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image & Audio to Video',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? imagePath;
  String? audioPath;
  String? videoPath; // Путь к созданному видео
  String? videoFileName; // Имя созданного видеофайла

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Video from Image & Audio',
            textAlign: TextAlign.center),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400, // Ограничиваем ширину колонны до 400 пикселей
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // 1. Кнопка выбора изображения
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      String? pickedImage = await pickImage();
                      if (pickedImage != null) {
                        setState(() {
                          imagePath = pickedImage;
                        });
                      }
                    },
                    child: const Text('Pick Image'),
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Контейнер для изображения (появляется только если изображение выбрано)
                if (imagePath != null)
                  Column(
                    children: [
                      Container(
                        height: 220,
                        // Устанавливаем фиксированную высоту для контейнера изображения
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.indigo),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 170,
                              child: Image.file(
                                File(imagePath!),
                                fit: BoxFit.contain, // Истинный вид изображения
                              ),
                            ),
                            SizedBox(height: 5),
                            Text('$imagePath!',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),

                // 3. Кнопка выбора аудио
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      String? pickedAudio = await pickAudio();
                      if (pickedAudio != null) {
                        setState(() {
                          audioPath = pickedAudio;
                        });
                      }
                    },
                    child: const Text('Pick Audio'),
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Контейнер для аудиоплеера (появляется только если аудио выбрано)
                if (audioPath != null)
                  Column(
                    children: [
                      Container(
                        height: 100,
                        // Устанавливаем фиксированную высоту для аудиоплеера
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.indigo),
                        ),
                        child: AudioPlayerWidget(audioPath: audioPath!),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),

                // 5. Кнопка для создания видео
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (imagePath != null && audioPath != null) {
                        // Показываем SnackBar, что видео создается
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Video is being created, please wait...'),
                            duration: Duration(seconds: 2), // Длительность отображения
                          ),
                        );

                        // Показать индикатор загрузки
                        showDialog(
                          context: context,
                          barrierDismissible: false, // Запрещаем закрывать диалог нажатиями вне
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    const SizedBox(width: 16),
                                    const Text('Creating Video...'),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                        // Создаем видео и получаем его путь
                        videoPath = await VideoCreator.createVideo(
                            imagePath!, audioPath!, context);

                        // Закрываем диалог загрузки
                        Navigator.pop(context);

                        setState(() {
                          // Получаем имя файла из полного пути
                          videoFileName = videoPath!.split('/').last;
                        });

                        // Выводим полный путь к созданному видео
                        if (videoPath != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Created Video: $videoFileName\nPath: $videoPath'),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select both image and audio files!'),
                          ),
                        );
                      }
                    },
                    child: const Text('Create Video'),
                  ),
                ),
                const SizedBox(height: 16),

                // 6. Контейнер для показа видео (появляется только если видео создано)
                if (videoPath != null)
                  Column(
                    children: [
                      Container(
                        height: 250,
                        // Устанавливаем высоту контейнера для видео
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.indigo),
                        ),
                        child: VideoPlayerWidget(
                            videoPath:
                                videoPath!), // Видео теперь прокручивается
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Кнопка для сохранения видео в выбранную папку
                          ElevatedButton(
                            onPressed: () async {
                              // Позволяем пользователю выбрать папку для сохранения
                              String? selectedPath =
                                  await FilePicker.platform.getDirectoryPath();
                              if (selectedPath != null && videoPath != null) {
                                // Сохраняем видео в выбранную папку
                                final File videoFile = File(videoPath!);
                                final String newVideoPath =
                                    '$selectedPath/$videoFileName';
                                await videoFile.copy(newVideoPath);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Video saved to: $newVideoPath')),
                                );
                              }
                            },
                            child: const Text('Save Video'),
                          ),
                          // Кнопка для удаления видео
                          ElevatedButton(
                            onPressed: () async {
                              if (videoPath != null) {
                                // Удаляем видео
                                final File videoFile = File(videoPath!);
                                if (await videoFile.exists()) {
                                  await videoFile.delete();
                                  setState(() {
                                    videoPath = null; // Очищаем путь
                                    videoFileName = null; // Очищаем имя файла
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Video deleted!')),
                                  );
                                }
                              }
                            },
                            child: const Text('Delete Video'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8), // Отступ перед текстом
                      // Текст для отображения имени файла и пути
                      if (videoFileName != null && videoPath != null)
                        Text(
                          'File: $videoFileName\nPath: $videoPath',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12), // Размер шрифта
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Виджет для воспроизведения видео
class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const VideoPlayerWidget({Key? key, required this.videoPath})
      : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {}); // Обновляем состояние после инициализации
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_controller.value.isInitialized)
          Container(
            width: double.infinity,
            height: 200, // Устанавливаем фиксированную высоту для видео
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: () {
                setState(() {
                  _controller.pause();
                  _controller.seekTo(Duration.zero); // Возвращаемся к началу
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
