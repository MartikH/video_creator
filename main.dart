import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_creator/styles/colors.dart';
import 'helpers/file_picker_helper.dart';
import 'styles/button_styles.dart';
import 'styles/container_styles.dart';
import 'styles/text_styles.dart';
import 'widgets/audio_player_widget.dart';
import 'widgets/video_creator.dart';
import 'widgets/video_player_widget.dart';

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
  String? videoPath;
  String? videoFileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Create Video from Image & Audio',
            style: AppTextStyles.bodyText),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
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
                    style: AppButtonStyles.elevatedButtonStyle,
                    child: Text('Pick Image', style: AppTextStyles.button),
                  ),
                ),
                const SizedBox(height: 16),
                if (imagePath != null)
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 240,
                        decoration: AppContainerStyles.boxStyle,
                        child: Column(
                          children: [
                            Container(
                              height: 170,
                              child: Image.file(
                                File(imagePath!),
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text('$imagePath!',
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.pathname),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
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
                    style: AppButtonStyles.elevatedButtonStyle,
                    child: Text('Pick Audio', style: AppTextStyles.button),
                  ),
                ),
                const SizedBox(height: 16),
                if (audioPath != null)
                  Column(
                    children: [
                      Container(
                        height: 100,
                        decoration: AppContainerStyles.boxStyle,
                        child: AudioPlayerWidget(audioPath: audioPath!),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (imagePath != null && audioPath != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: AppColors.background,
                            content: Text(
                              'Video is being created, please wait...',
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 5),
                          ),
                        );

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    const SizedBox(width: 16),
                                    Text('Creating Video...',
                                        style: AppTextStyles.bodyText),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                        videoPath = await VideoCreator.createVideo(
                            imagePath!, audioPath!, context);

                        Navigator.pop(context);
                        setState(() {
                          videoFileName = videoPath!.split('/').last;
                        });

                        if (videoPath != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.background,
                              content: Text(
                                'Created Video: $videoFileName\nPath: $videoPath',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: AppColors.background,
                            content: Text(
                              'Please select both image and audio files!',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    },
                    style: AppButtonStyles.elevatedButtonStyle,
                    child: Text('Create Video', style: AppTextStyles.button),
                  ),
                ),
                const SizedBox(height: 16),
                if (videoPath != null)
                  Column(
                    children: [
                      Container(
                        height: 250,
                        decoration: AppContainerStyles.boxStyle,
                        child: VideoPlayerWidget(videoPath: videoPath!),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              String? selectedPath =
                                  await FilePicker.platform.getDirectoryPath();
                              if (selectedPath != null && videoPath != null) {
                                final File videoFile = File(videoPath!);
                                final String newVideoPath =
                                    '$selectedPath/$videoFileName';
                                await videoFile.copy(newVideoPath);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: AppColors.background,
                                      content: Text(
                                        'Video saved to: $newVideoPath',
                                        textAlign: TextAlign.center,
                                      )),
                                );
                              }
                            },
                            style: AppButtonStyles.elevatedButtonStyle,
                            child:
                                Text('Save Video', style: AppTextStyles.button),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (videoPath != null) {
                                final File videoFile = File(videoPath!);
                                if (await videoFile.exists()) {
                                  await videoFile.delete();
                                  setState(() {
                                    videoPath = null;
                                    videoFileName = null;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: AppColors.background,
                                        content: Text(
                                          'Video deleted!',
                                          textAlign: TextAlign.center,
                                        )),
                                  );
                                }
                              }
                            },
                            style: AppButtonStyles.elevatedButtonStyle,
                            child: Text('Delete Video',
                                style: AppTextStyles.button),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (videoFileName != null && videoPath != null)
                        Text(
                          'File: $videoFileName\nPath: $videoPath',
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.pathname,
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
