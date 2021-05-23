import 'package:flutter/material.dart';

const colorPrimary = Color(0xFF03254c);
const colorLight = Color(0xFF1261A0);

const MaterialColor appColorSwatch = MaterialColor(
  0xFF03254c,
  <int, Color>{
    50: Color(0xFF58CCED),
    100: Color(0xFF58CCED),
    200: Color(0xFF3895D3),
    300: Color(0xFF1261A0),
    400: Color(0xFF1261A0),
    500: Color(0xFF03254c),
    600: Color(0xff021a36),
    700: Color(0xff021a36),
    800: Color(0xff021832),
    900: Color(0xff021934),
  },
);


const backgroundGradient = LinearGradient(
  stops: [
    0, 0.5, 0.5, 1
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: <Color>[
    colorLight,
    colorPrimary,
    colorPrimary,
    colorLight,
  ], // red to yellow
  tileMode: TileMode.clamp, // repeats the gradient over the canvas
);