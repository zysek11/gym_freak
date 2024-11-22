import 'dart:math';
import 'package:flutter/material.dart';

class CircularCurvedSegments extends StatelessWidget {
  final int numberOfVertices;
  final int numberOfConnectors;

  const CircularCurvedSegments({Key? key, required this.numberOfVertices,
    required this.numberOfConnectors}) : super(key: key);

  CustomPaint reformatCircle(){
    int nov_floor = numberOfVertices;
    int noc_floor = numberOfConnectors;
    if(numberOfVertices > 10){
      noc_floor = ((numberOfConnectors.toDouble() / numberOfVertices.toDouble())*10).toInt();
      nov_floor = 10;
    }
    return CustomPaint(
      size: Size(90, 90), // Size of the widget
      painter: CircleCurvedSegmentsPainter(numberOfVertices: nov_floor, numberOfConnectors: noc_floor),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Image.asset("assets/icons/vitamin.png", height: 32, width: 32,),
          reformatCircle(),
        ],
      ),
    );
  }
}

class CircleCurvedSegmentsPainter extends CustomPainter {
  final int numberOfVertices;
  final int numberOfConnectors;

  CircleCurvedSegmentsPainter({
    required this.numberOfVertices,
    required this.numberOfConnectors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2); // Adjust radius as needed
    final angleIncrement = 2 * pi / numberOfVertices; // Angle between each vertex
    int connCounter = 0;

    final paint = Paint()
      ..color =  const Color(0xFF2A8CBB)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final vertexPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    List<Offset> vertices = [];

    for (int i = 0; i < numberOfVertices; i++) {
      final angle = i * angleIncrement - pi / 2; // Start at top center

      // Calculate each vertex's position on the circumference
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      vertices.add(Offset(x, y));
    }

    // Draw curved lines between each vertex
    for (int i = 0; i < vertices.length; i++) {
      if (connCounter == numberOfConnectors) {
        paint.color = Colors.white;
      }
      final startAngle = i * angleIncrement - pi / 2; // Start at top center
      final sweepAngle = angleIncrement;

      // Draw arc segment between vertices
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      // Draw white dot at each vertex
      canvas.drawCircle(vertices[i], 6, vertexPaint);
      connCounter++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
