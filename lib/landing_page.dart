import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey.withOpacity(0.5),
        ),
        // Dot Grid Overlay
        Positioned.fill(
          child: CustomPaint(
            painter: DotGridPainter(),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: MediaQuery.of(context).size.height * 0.4, // Adjust this value for desired height
          child: Text(
            'FLOATY',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 80.0,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontFamily: 'ModernFont',
            ),
          ),
        ),
      ],
    );
  }
}


class DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dotSpacing = 20.0; // Adjust for desired spacing between dots
    final dotPaint = Paint()
      ..color = Colors.grey.withOpacity(0.4) // Semi-transparent grey
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    for (var i = 1.0; i < size.width; i += dotSpacing) {
      for (var j = 0.0; j < size.height; j += dotSpacing) {
        canvas.drawCircle(Offset(i, j), 1.1, dotPaint); // Adjust the radius (1.0 here) for dot size
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
