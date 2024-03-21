  import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';

Positioned superiorBackground(Size size) {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      child: Container(
        height: size.height * 0.25,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            color: Color.fromRGBO(164, 47, 193, 1.0)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: CustomPaint(
            painter: BubblePainter(),
          ),
        ),
      ),
    );
  }