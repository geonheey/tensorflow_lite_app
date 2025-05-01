import 'dart:io';
import 'package:flutter/material.dart';
import '../painter/keypoint_painter.dart';
import '../services/image_service.dart';
import 'package:image/image.dart' as img;

import '../services/model_service.dart';

class MoveNetApp extends StatefulWidget {
  @override
  _MoveNetAppState createState() => _MoveNetAppState();
}

class _MoveNetAppState extends State<MoveNetApp> {
  File? _image;
  img.Image? _originalImage;
  List<List<double>>? _keypoints;
  final _modelService = ModelService();

  @override
  void initState() {
    super.initState();
    _modelService.loadModel();
  }

  Future<void> pickAndPredictImage() async {
    final result = await ImageService.pickImageAndPreprocess();
    if (result == null || !_modelService.isLoaded) return;

    setState(() {
      _image = result.file;
      _originalImage = result.originalImage;
    });

    final keypoints = await _modelService.predict(result.inputImage);
    setState(() {
      _keypoints = keypoints;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MoveNet Pose Estimation")),
      body: Center(
        child: _image == null
            ? Text("이미지를 업로드하세요")
            : Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Image.file(_image!),
                  if (_keypoints != null && _originalImage != null)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: KeypointPainter(_keypoints!, _originalImage!),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.image),
        onPressed: pickAndPredictImage,
      ),
    );
  }
}
