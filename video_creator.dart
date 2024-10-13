import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import '../helpers/error_helper.dart';

class VideoCreator {
  static Future<String?> createVideo(String imagePath, String audioPath, BuildContext context) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String outputPath = '${appDocDir.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';
    String command = '-loop 1 -i "$imagePath" -i "$audioPath" -vf "scale=720:400" -c:v mpeg4 -b:v 800k -c:a aac -b:a 192k -shortest "$outputPath"';

    try {
      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        return outputPath;
      } else {
        ErrorHelper.showError(context, 'Error creating video: $returnCode');
        return null;
      }
    } catch (e) {
      ErrorHelper.showError(context, 'Exception occurred while creating video: $e');
      return null;
    }
  }
}
