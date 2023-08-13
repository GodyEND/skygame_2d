import 'dart:async';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/utils.dart/shader_manager.dart';

mixin SelectableSprite on SpriteComponent {
  int get index => -1;
  bool isSelected = false;
  bool isSelectable = true;
  double selectedBorderThickness = 10.0;
  Color selectedBorderColor = Colors.orange.withOpacity(0.75);

  late ui.Image _shrinkedImg;
  late Rect _shrinkedRect;
  @override
  FutureOr<void> onLoad() async {
    final res = size.toRect();
    Vector2 offset =
        Vector2(res.width - res.width * 0.9, res.height - res.height * 0.9);
    _shrinkedRect = Rect.fromLTWH(offset.x * 0.5, offset.y * 0.5,
        res.width - offset.x, res.height - offset.y);

    _shrinkedImg = await sprite!.image.resize(_shrinkedRect.toVector2());
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    var res = size.toRect();
    if (isSelected) {
      final shader = ShaderManager.getOutlineShader(
        resolution: Vector2(res.width, res.height),
        img: sprite!.image,
        thickness: selectedBorderThickness,
        borderColor: selectedBorderColor,
        isSelectable: isSelectable,
      );

      final newPaint = Paint()..shader = shader;
      canvas.drawRect(res, newPaint);
    } else if (isSelectable == false) {
      final shader = ShaderManager.getGreyscaleShader(
        rect: _shrinkedRect,
        img: _shrinkedImg,
      );
      final newPaint = Paint()..shader = shader;
      canvas.drawRect(_shrinkedRect, newPaint);
    } else {
      final shader = ShaderManager.getColorShader(
        rect: _shrinkedRect,
        img: _shrinkedImg,
      );
      final newPaint = Paint()..shader = shader;
      canvas.drawRect(_shrinkedRect, newPaint);
    }
  }
}
