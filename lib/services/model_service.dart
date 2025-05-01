import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ModelService {
  Interpreter? _interpreter;

  bool get isLoaded => _interpreter != null;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/movenet_lightning.tflite');
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future<List<List<double>>> predict(img.Image image) async {
    final input = List.generate(
      1,
          (_) => List.generate(
        192,
            (y) => List.generate(
          192,
              (x) {
            final pixel = image.getPixel(x, y);
            return [
              img.getRed(pixel),
              img.getGreen(pixel),
              img.getBlue(pixel),
            ];
          },
        ),
      ),
    );

    final output = List.generate(1, (_) => List.generate(1, (_) => List.generate(17, (_) => List.filled(3, 0.0))));
    _interpreter!.run(input, output);
    return output[0][0].map<List<double>>((e) => List<double>.from(e)).toList();
  }
}
