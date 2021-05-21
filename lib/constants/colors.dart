import 'package:flutter/material.dart';

const colorPrimary = Color(0xFF171F6A);
const colorLight = Color(0xFF2891E5);

const MaterialColor appColorSwatch = MaterialColor(
  0xFF171F6A,
  <int, Color>{
    50: Color(0xFF747DD9),
    100: Color(0xFF4F5AC2),
    200: Color(0xFF333D99),
    300: Color(0xFF242D86),
    400: Color(0xFF1B2372),
    500: Color(0xFF171F6A),
    600: Color(0xFF171F6A),
    700: Color(0xFF171F6A),
    800: Color(0xFF171F6A),
    900: Color(0xFF171F6A),
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