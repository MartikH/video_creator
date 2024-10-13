import 'package:file_picker/file_picker.dart';

Future<String?> pickImage() async {
  final result = await FilePicker.platform.pickFiles(type: FileType.image);
  return result?.files.first.path;
}

Future<String?> pickAudio() async {
  final result = await FilePicker.platform.pickFiles(type: FileType.audio);
  return result?.files.first.path;
}
