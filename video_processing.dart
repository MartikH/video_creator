import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';

class VideoProcessing {
  static Future<String?> processVideo(String command) async {
    try {
      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        return command;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
