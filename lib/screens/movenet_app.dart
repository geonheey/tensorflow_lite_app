import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

import '../painter/keypoint_painter.dart';

class MoveNetApp extends StatefulWidget {
  @override
  _MoveNetAppState createState() => _MoveNetAppState();
}

class _MoveNetAppState extends State<MoveNetApp> {
  Interpreter? _interpreter;
  File? _image;
  List<List<double>>? _keypoints;
  img.Image? _originalImage;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/movenet_lightning.tflite');
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future<void> pickAndPredictImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null || _interpreter == null) return;

    setState(() {
      _image = File(pickedFile.path);
    });

    final rawImage = File(pickedFile.path).readAsBytesSync();
    _originalImage = img.decodeImage(rawImage);
    final resizedImage = img.copyResize(_originalImage!, width: 192, height: 192);

    final input = List.generate(1, (_) => List.generate(192, (y) => List.generate(192, (x) {
      final pixel = resizedImage.getPixel(x, y);
      return [img.getRed(pixel), img.getGreen(pixel), img.getBlue(pixel)];
    })));

    final output = List.generate(1, (_) => List.generate(1, (_) => List.generate(17, (_) => List.filled(3, 0.0))));
    _interpreter!.run(input, output);

    final keypoints = output[0][0].map<List<double>>((e) => List<double>.from(e)).toList();

    setState(() {
      _keypoints = keypoints;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MoveNet Pose Estimation")),
      body: Center(
        child: _image == null || _originalImage == null
            ? Text("이미지를 업로드하세요")
            : LayoutBuilder(
          builder: (context, constraints) {
            final imageAspectRatio = _originalImage!.width / _originalImage!.height;
            final displayWidth = constraints.maxWidth;
            final displayHeight = displayWidth / imageAspectRatio;

            return SizedBox(
              width: displayWidth,
              height: displayHeight,
              child: Stack(
                children: [
                  Image.file(
                    _image!,
                    width: displayWidth,
                    height: displayHeight,
                    fit: BoxFit.fill,
                  ),
                  if (_keypoints != null)
                    CustomPaint(
                      size: Size(displayWidth, displayHeight),
                      painter: KeypointPainter(_keypoints!, _originalImage!),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.image),
        onPressed: pickAndPredictImage,
      ),
    );
  }
}
