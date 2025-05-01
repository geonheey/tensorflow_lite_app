import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import '../utils/constants.dart';

class KeypointPainter extends CustomPainter {
  final List<List<double>> keypoints;
  final img.Image image;

  KeypointPainter(this.keypoints, this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint circlePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;

    final scaleX = size.width / image.width;
    final scaleY = size.height / image.height;

    for (var kp in keypoints) {
      final dx = kp[1] * image.width * scaleX;
      final dy = kp[0] * image.height * scaleY;
      canvas.drawCircle(Offset(dx, dy), 4.0, circlePaint);
    }

    for (var pair in connectedKeypoints) {
      final p1 = keypoints[pair[0]];
      final p2 = keypoints[pair[1]];

      final x1 = p1[1] * image.width * scaleX;
      final y1 = p1[0] * image.height * scaleY;
      final x2 = p2[1] * image.width * scaleX;
      final y2 = p2[0] * image.height * scaleY;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
