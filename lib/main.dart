import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as fl;
import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cube demo',
      theme: ThemeData(
        primarySwatch: fl.Colors.blue,
      ),
      home: const MyHomePage(title: 'Cube'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DiTreDiController controller;

  @override
  void initState() {
    super.initState();
    controller = DiTreDiController(
      ambientLightStrength: 0.8,
      rotationX: -45,
      rotationY: 45,
      rotationZ: 45,
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: fl.Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: DiTreDiDraggable(
                controller: controller,
                child: DiTreDi(
                  figures: [
                    Line3D(Vector3(-5, 0, 0), Vector3(5, 0, 0), color: fl.Colors.red, width: 1.5),
                    Line3D(Vector3(0, -5, 0), Vector3(0, 5, 0),
                        color: fl.Colors.yellow, width: 1.5),
                    Line3D(Vector3(0, 0, -5), Vector3(0, 0, 5), color: fl.Colors.green, width: 1.5),
                    getCube(),
                  ],
                  controller: controller,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Group3D getCube() {
    int count = 3;
    // half the size of a square
    double size = 1.0;
    double offset = size * count;
    List<Model3D> items = [];
    items.add(
      TransformModifier3D(
        getFace(fl.Colors.red, size, count, count),
        Matrix4.identity()..translate(Vector3(0, 0, -offset)),
      ),
    );
    items.add(
      TransformModifier3D(
        getFace(fl.Colors.orange, size, count, count),
        Matrix4.identity()
          ..translate(Vector3(0, 0, offset))
          ..setRotationY(pi),
      ),
    );
    items.add(
      TransformModifier3D(
        getFace(fl.Colors.blue, size, count, count),
        Matrix4.identity()
          ..translate(Vector3(offset, 0, 0))
          ..setRotationY(-pi / 2),
      ),
    );
    items.add(
      TransformModifier3D(
        getFace(fl.Colors.green, size, count, count),
        Matrix4.identity()
          ..translate(Vector3(-offset, 0, 0))
          ..setRotationY(pi / 2),
      ),
    );
    items.add(
      TransformModifier3D(
        getFace(fl.Colors.yellow, size, count, count),
        Matrix4.identity()
          ..translate(Vector3(0, offset, 0))
          ..setRotationX(pi / 2),
      ),
    );
    items.add(
      TransformModifier3D(
        getFace(fl.Colors.white, size, count, count),
        Matrix4.identity()
          ..translate(Vector3(0, -offset, 0))
          ..setRotationX(-pi / 2),
      ),
    );
    return Group3D(items);
  }

  Group3D getFace(Color color, double size, int rows, int cols) {
    List<Plane3D> planes = [];
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        final Vector3 pos =
            Vector3(i * size * 2 + size - rows * size, j * size * 2 + size - cols * size, 0);
        planes.add(Plane3D(size - 0.01, Axis3D.z, false, pos, color: color));
      }
    }

    return Group3D(planes);
  }
}
