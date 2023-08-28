import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/utils.dart/shader_manager.dart';

mixin SelectableSprite on SpriteComponent {
  bool isHovered = false;
  bool isSelected = false;
  bool isSelectable = true;
  double selectedBorderThickness = 10.0;
  final Vector2 unselectedScale = Vector2.all(0.75);
  Color hoveredBorderColor = Colors.white.withOpacity(0.75);
  Color selectedBorderColor = Colors.orange.withOpacity(0.75);
  late final Vector2 offset;
  late final Vector2 unselectedPos;
  late final Vector2 originalPos;

  int get index => -1;
  Vector2 get getInitPosition =>
      (position == unselectedPos) ? position - offset : position;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final res = size.toRect();
    originalPos = position;
    offset = Vector2(res.width - res.width * unselectedScale.x,
            res.height - res.height * unselectedScale.y) *
        0.5;
    unselectedPos = position + offset;
  }

  @override
  void render(Canvas canvas) {
    // super.render(canvas);
    // canvas.drawColor(Colors.transparent, BlendMode.multiply);
    var res = size.toRect();
    if (isSelected || isHovered) {
      final shader = ShaderManager.getOutlineShader(
        resolution: Vector2(res.width, res.height),
        img: sprite!.image,
        thickness: selectedBorderThickness,
        borderColor: isSelected ? selectedBorderColor : hoveredBorderColor,
        isSelectable: isSelectable,
      );

      final newPaint = Paint()..shader = shader;
      canvas.drawRect(res, newPaint);
      scale = Vector2(1, 1);
      position = getInitPosition;
    } else if (isSelectable == false) {
      final shader = ShaderManager.getGreyscaleShader(
        rect: res,
        img: sprite!.image,
      );
      final newPaint = Paint()..shader = shader;
      canvas.drawRect(res, newPaint);
      scale = unselectedScale;
      position = unselectedPos;
    } else {
      final shader = ShaderManager.getColorShader(
        rect: res,
        img: sprite!.image,
      );
      final newPaint = Paint()..shader = shader;
      canvas.drawRect(res, newPaint);
      scale = unselectedScale;
      position = unselectedPos;
    }
  }
}
