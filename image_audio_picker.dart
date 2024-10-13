import 'package:flutter/material.dart';
import '../helpers/file_picker_helper.dart';

Future<void> pickFiles(BuildContext context) async {
  String? imagePath = await pickImage();
  String? audioPath = await pickAudio();

  if (imagePath == null || audioPath == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please select both image and audio files!')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Files selected successfully!')),
    );
  }
}
