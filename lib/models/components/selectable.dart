import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

mixin SelectableSprite on SpriteComponent {
  bool isSelected = false;
  bool isSelectable = true;
  double selectedBorderThickness = 10.0;
  Color selectedBorderColor = Colors.lightBlue.withOpacity(0.75);
  int lastUpdateTime = DateTime.now().millisecondsSinceEpoch;

  late FragmentProgram _program;
  late FragmentProgram _program2;
  late FragmentProgram _program3;
  @override
  FutureOr<void> onLoad() async {
    // TODO: Load Shaders on application start
    _program = await FragmentProgram.fromAsset(Constants.shaders.outline);
    _program2 = await FragmentProgram.fromAsset(Constants.shaders.greyscale);
    _program3 = await FragmentProgram.fromAsset(Constants.shaders.color);
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    final now = DateTime.now().millisecondsSinceEpoch;
    // double elapsedTime = (now - lastUpdateTime).toDouble() / 1000.0;
    // lastUpdateTime = now;
    final tick = (now / 30) % 360;
    final angle = tick * pi / 180.0;
    FragmentShader shader;
    final res = size.toRect();
    if (isSelected) {
      // TODO: animated outline
      // effect text
      // timestep
      // animation speed
      shader = _program.fragmentShader();
      shader.setFloat(0, res.width);
      shader.setFloat(1, res.height);
      shader.setImageSampler(0, sprite!.image);
      final aniTex = Constants.images.outlineTex;
      if (aniTex != null) {
        shader.setImageSampler(1, aniTex);
      }
      shader.setFloat(2, selectedBorderThickness);
      shader.setFloat(3, selectedBorderColor.red.toDouble() / 255);
      shader.setFloat(4, selectedBorderColor.green.toDouble() / 255);
      shader.setFloat(5, selectedBorderColor.blue.toDouble() / 255);
      shader.setFloat(6, selectedBorderColor.opacity);
      shader.setFloat(7, angle);
      shader.setFloat(8, isSelectable ? 1.0 : 0.0);
    } else if (isSelectable == false) {
      shader = _program2.fragmentShader();
      shader.setFloat(0, res.width);
      shader.setFloat(1, res.height);
      shader.setImageSampler(0, sprite!.image);
    } else {
      shader = _program3.fragmentShader();
      shader.setFloat(0, res.width);
      shader.setFloat(1, res.height);
      shader.setImageSampler(0, sprite!.image);
    }

    final newPaint = Paint()..shader = shader;
    canvas.drawRect(res, newPaint);
  }
}
