import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

FragmentProgram? _program;

void main() async {
  _program = await FragmentProgram.fromAsset('shaders/attractorshader.frag');
  runApp(MyApp());
}

double width = 0.0;
double height = 0.0;
double mouseX = 0.0;
double mouseY = 0.0;
int currentSelected = 0;

bool place = false;

class body {
  double mass;
  double coordX;
  double coordY;
  double volume;

  body(this.mass, this.coordX, this.coordY, this.volume);
}

List<body> objects = [
  body(0.05, 0.0, -1.0, 0.15),
  body(0.0, 0.0, 0.0, 0.0),
  body(0.0, 0.0, 0.0, 0.0),
  body(0.0, 0.0, 0.0, 0.0),
  body(0.0, 0.00, 0.0, 0.0)
];

class fractalState {
  double zoom = 1.0;
  double coordX = 0.0;
  double coordY = 0.0;
  List<body> bodies = objects;
  FocusNode focusNode = FocusNode();
}

double dist(double x1, double y1, double x2, double y2) {
  return sqrt(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1)));
}

class ShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final fractalState state;

  ShaderPainter(FragmentShader fragmentShader, this.state)
      : shader = fragmentShader;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    width = size.width;
    height = size.height;
    shader.setFloat(0, width);
    shader.setFloat(1, height);
    shader.setFloat(2, state.zoom);
    shader.setFloat(3, state.coordX);
    shader.setFloat(4, state.coordY);

    shader.setFloat(5, state.bodies[0].mass);
    shader.setFloat(6, state.bodies[0].coordX);
    shader.setFloat(7, state.bodies[0].coordY);
    shader.setFloat(8, state.bodies[0].volume);

    shader.setFloat(9, state.bodies[1].mass);
    shader.setFloat(10, state.bodies[1].coordX);
    shader.setFloat(11, state.bodies[1].coordY);
    shader.setFloat(12, state.bodies[1].volume);

    shader.setFloat(13, state.bodies[2].mass);
    shader.setFloat(14, state.bodies[2].coordX);
    shader.setFloat(15, state.bodies[2].coordY);
    shader.setFloat(16, state.bodies[2].volume);

    shader.setFloat(17, state.bodies[3].mass);
    shader.setFloat(18, state.bodies[3].coordX);
    shader.setFloat(19, state.bodies[3].coordY);
    shader.setFloat(20, state.bodies[3].volume);

    shader.setFloat(21, state.bodies[4].mass);
    shader.setFloat(22, state.bodies[4].coordX);
    shader.setFloat(23, state.bodies[4].coordY);
    shader.setFloat(24, state.bodies[4].volume);

    paint.shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FractalWidget extends StatefulWidget {
  final fractalState _intialState;

  FractalWidget(this._intialState);

  @override
  State<StatefulWidget> createState() {
    return FractalWidgetState(_intialState);
  }
}

class FractalWidgetState extends State<FractalWidget> {
  fractalState _state;
  FocusNode _focus = FocusNode();

  FractalWidgetState(this._state);

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        focusNode: _state.focusNode,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.keyQ)) {
            setState(() {
              _state.zoom = _state.zoom * 1.05;
            });
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyE)) {
            setState(() {
              _state.zoom = _state.zoom / 1.05;
            });
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyW)) {
            setState(() {
              _state.coordY = _state.coordY - (0.15 / _state.zoom);
            });
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyS)) {
            setState(() {
              _state.coordY = _state.coordY + (0.15 / _state.zoom);
            });
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyA)) {
            setState(() {
              _state.coordX = _state.coordX - (0.15 / _state.zoom);
            });
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyD)) {
            setState(() {
              _state.coordX = _state.coordX + (0.15 / _state.zoom);
            });
          }
        },
        child: CustomPaint(
          painter: ShaderPainter(_program!.fragmentShader(), _state),
        ));
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  fractalState theState = fractalState();

  final myControllerM = TextEditingController();
  final myControllerV = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text('Fractal viewer', style: TextStyle(fontSize: 28))),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            flex: 10,
            child: Container(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 60, 183, 240)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text('Orbital simulation'),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: myControllerM,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true, // Fill the background with a color
                              fillColor: Color.fromARGB(255, 80, 80, 255),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: myControllerV,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true, // Fill the background with a color
                              fillColor: Color.fromARGB(255, 120, 120, 255),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        place = true;
                        for (int i = 0; i < 5; i++) {
                          if (theState.bodies[i].volume == 0.0) {
                            currentSelected = i;
                          }
                        }
                        setState(() {});
                      },
                      child: const Text("new object"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 89,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Listener(
                    onPointerDown: (details) {
                      setState(() {
                        mouseX = theState.coordX +
                            (2.0 *
                                ((details.localPosition.dx - (width / 2.0)) /
                                    min(width, height)) /
                                theState.zoom);
                        mouseY = theState.coordY +
                            (2.0 *
                                ((details.localPosition.dy - (height / 2.0)) /
                                    min(width, height)) /
                                theState.zoom);
                      });
                      theState.focusNode.requestFocus();
                      for (int i = 0; i < 5; i++) {
                        if (dist(theState.bodies[i].coordX,
                                theState.bodies[i].coordY, mouseX, mouseY) <
                            theState.bodies[i].volume) {
                          currentSelected = i;
                        }
                      }

                      if (place) {
                        for (int i = 0; i < 5; i++) {
                          if (theState.bodies[i].volume == 0.0) {
                            theState.bodies[i] = body(
                                double.parse(myControllerM.text),
                                mouseX,
                                mouseY,
                                double.parse(myControllerV.text));
                          }
                        }
                      }
                      setState(() {});
                    },
                    child: FractalWidget(theState),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
