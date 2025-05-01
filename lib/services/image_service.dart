import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class ImagePreprocessResult {
  final File file;
  final img.Image originalImage;
  final img.Image inputImage;

  ImagePreprocessResult(this.file, this.originalImage, this.inputImage);
}

class ImageService {
  static Future<ImagePreprocessResult?> pickImageAndPreprocess() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    final file = File(pickedFile.path);
    final raw = file.readAsBytesSync();
    final original = img.decodeImage(raw)!;
    final resized = img.copyResize(original, width: 192, height: 192);

    return ImagePreprocessResult(file, original, resized);
  }
}
