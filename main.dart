//Mandelbrot set Nea

import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

FragmentProgram? _program;

void main() async {
  _program =
      await FragmentProgram.fromAsset('shaders/customfractalshader.frag');
  runApp(MyApp());
}

double width = 0.0;
double height = 0.0;
double mouseX = 0.0;
double mouseY = 0.0;

List<double> parse(String expr) {
  String expression = expr;
  List<double> result = [];

  for (int i = 0; i < expression.length; i++) {
    if (expression.substring(i, i + 1) == " " ||
        expression.substring(i, i + 1) == "*") {
      expression = expression.substring(0, i) + expression.substring(i + 1);
    }
  }
  int previous = 0;
  for (int i = 1; i < expression.length; i++) {
    if (expression[i] == "+" || expression[i] == "-") {
      result = result + encode(expression.substring(previous, i));
      previous = i;
    }
  }
  result = result + encode(expression.substring(previous));
  for (int i = 0; i < 13; i++) {
    if (result.length >= 12) {
      break;
    }
    result = result + [0.0];
  }
  return result;
}

List<double> encode(String Expr) {
  String expression = Expr;
  List<double> returned = [0.0, 0.0, 0.0];

  int start = 0;
  int end = 0;
  if (expression.substring(0, 1) == "-") {
    returned[0] = -1.0;
    expression = expression.substring(1);
  } else {
    returned[0] = 1.0;
    if (expression.substring(0, 1) == "+") {
      expression = expression.substring(1);
    }
  }

  for (int i = 0; i < expression.length; i++) {
    if (expression[i] == "x" || expression[i] == "y") {
      if (i != 0) {
        returned[0] = returned[0] * double.parse(expression.substring(0, i));
      }
      break;
    }
  }
  for (int i = 0; i < expression.length; i++) {
    if (expression.substring(i, i + 1) == "x") {
      returned[1] = 1.0;
      if (i + 2 <= expression.length) {
        if (expression.substring(i + 1, i + 2) == "^") {
          end = expression.length;
          start = i + 2;
          for (int i = start; i < expression.length; i++) {
            if (expression.substring(i, i + 1) == "y") {
              end = i;
            }
          }
          returned[1] = double.parse(expression.substring(start, end));
        }
      }
    }

    if (expression.substring(i, i + 1) == "y") {
      returned[2] = 1.0;
      if (i + 2 <= expression.length) {
        if (expression.substring(i + 1, i + 2) == "^") {
          end = expression.length;
          start = i + 2;
          for (int i = start; i < expression.length; i++) {
            if (expression.substring(i, i + 1) == "x") {
              end = i;
            }
          }
          returned[2] = double.parse(expression.substring(start, end));
        }
      }
    }
  }
  return returned;
}

class fractalState {
  double zoom = 1.0;
  double coordX = 0.0;
  double coordY = 0.0;
  bool julia;
  FocusNode focusNode = FocusNode();
  List<double> exprX = [
    1.0,
    2.0,
    0.0,
    -1.0,
    0.0,
    2.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0
  ];
  List<double> exprY = [
    2.0,
    1.0,
    1.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0
  ];

  fractalState(this.julia);
}

// fetches mouse pointer location

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
    shader.setFloat(5, state.julia ? 1.0 : 0.0);
    shader.setFloat(6, mouseX);
    shader.setFloat(7, mouseY);
    for (int i = 0; i < 12; i++) {
      shader.setFloat(8 + i, state.exprX[i]);
    }
    for (int i = 0; i < 12; i++) {
      shader.setFloat(20 + i, state.exprY[i]);
    }

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
  //double _zoom = 1.0;
  fractalState leftState = fractalState(false);
  fractalState rightState = fractalState(true);

  final myControllerX = TextEditingController();
  final myControllerY = TextEditingController();

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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Enter a custom equation:'),
                        Text('One is needed for both the X and Y coordinates'),
                        Text('C is added automatically'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: myControllerX,
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
                            controller: myControllerY,
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
                        setState(() {
                          leftState.exprX = parse(myControllerX.text);
                          leftState.exprY = parse(myControllerY.text);
                          rightState.exprX = parse(myControllerX.text);
                          rightState.exprY = parse(myControllerY.text);
                        });
                      },
                      child: const Text("refresh"),
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
                        leftState.focusNode.requestFocus();
                        mouseX = leftState.coordX +
                            (2.0 *
                                ((details.localPosition.dx - (width / 2.0)) /
                                    min(width, height)) /
                                leftState.zoom);
                        mouseY = leftState.coordY +
                            (2.0 *
                                ((details.localPosition.dy - (height / 2.0)) /
                                    min(width, height)) /
                                leftState.zoom);
                      });
                    },
                    child: FractalWidget(leftState),
                  ),
                ),
                Expanded(
                  child: Listener(
                    onPointerDown: (details) {
                      setState(() {
                        rightState.focusNode.requestFocus();
                      });
                    },
                    child: FractalWidget(rightState),
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
