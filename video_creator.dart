import 'dart:io';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // Импортируем для работы с путями
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart'; // Убедитесь, что библиотека правильно импортирована

class VideoCreator {
  static Future<String?> createVideo(String imagePath, String audioPath, BuildContext context) async {
    // Получаем директорию для хранения файла
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String outputPath = '${appDocDir.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';

    // Команда ffmpeg с изменением размера изображения
    String command = '-loop 1 -i "$imagePath" -i "$audioPath" -vf "scale=720:400" -c:v mpeg4 -b:v 800k -c:a aac -b:a 192k -shortest "$outputPath"';

    try {
      // Выполняем команду
      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        return outputPath; // Возвращаем путь к созданному видео
      } else {
        // Обработка ошибок
        final log = await session.getLogs();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating video: $returnCode\nLog: ${log.toString()}')),
        );
        return null;
      }
    } catch (e) {
      // Обработка исключений
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exception occurred while creating video: $e')),
      );
      return null;
    }
  }
}
