import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        hintColor: Colors.blueAccent,
      ),
      home: const DrawingApp(),
    );
  }
}

class DrawingApp extends StatefulWidget {
  const DrawingApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DrawingAppState createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp> {
  List<DrawingPoint> points = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doodle App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                points.clear();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  points.add(DrawingPoint(
                    points: details.localPosition,
                    paint: Paint()
                      ..color = selectedColor
                      ..strokeCap = StrokeCap.round
                      ..strokeWidth = strokeWidth,
                  ));
                });
              },
              onPanEnd: (details) {
                // ignore: prefer_typing_uninitialized_variables
                var value;
                points.add(value);
              },
              child: CustomPaint(
                painter: DrawingPainter(points: points),
                size: Size.infinite,
              ),
            ),
          ),
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const SizedBox(width: 10),
                ColorPickerButton(Colors.black, updateColor),
                ColorPickerButton(Colors.red, updateColor),
                ColorPickerButton(Colors.blue, updateColor),
                ColorPickerButton(Colors.green, updateColor),
                ColorPickerButton(Colors.yellow, updateColor),
                const SizedBox(width: 20),
                BrushSizeButton(5.0, updateBrushSize),
                BrushSizeButton(10.0, updateBrushSize),
                BrushSizeButton(15.0, updateBrushSize),
                BrushSizeButton(20.0, updateBrushSize),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void updateColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  void updateBrushSize(double size) {
    setState(() {
      strokeWidth = size;
    });
  }
}

class DrawingPoint {
  Offset points;
  Paint paint;

  DrawingPoint({required this.points, required this.paint});
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> points;

  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
            points[i]!.points, points[i + 1]!.points, points[i]!.paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(
            PointMode.points, [points[i]!.points], points[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ColorPickerButton extends StatelessWidget {
  final Color color;
  final Function(Color) onTap;

  const ColorPickerButton(this.color, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(color);
      },
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}

class BrushSizeButton extends StatelessWidget {
  final double size;
  final Function(double) onTap;

  const BrushSizeButton(this.size, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(size);
      },
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Center(
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
