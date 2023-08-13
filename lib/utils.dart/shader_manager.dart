import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

class ShaderManager {
  static Map<String, FragmentProgram> _shaders = {};

  static Future<bool> loadShaders() async {
    try {
      _shaders[Constants.shaders.outline] =
          await FragmentProgram.fromAsset(Constants.shaders.outline);
      _shaders[Constants.shaders.greyscale] =
          await FragmentProgram.fromAsset(Constants.shaders.greyscale);
      _shaders[Constants.shaders.color] =
          await FragmentProgram.fromAsset(Constants.shaders.color);
      return true;
    } catch (e) {
      print('shader loading failed');
      return false;
    }
  }

  static FragmentShader getOutlineShader({
    required Vector2 resolution,
    required Image img,
    required double thickness,
    required Color borderColor,
    required bool isSelectable,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final tick = (now / 30) % 360;
    final angle = tick * pi / 180.0;

    final shader = _shaders[Constants.shaders.outline]!.fragmentShader();
    shader.setFloat(0, resolution.x);
    shader.setFloat(1, resolution.y);
    shader.setImageSampler(0, img);
    final aniTex = Constants.images.outlineTex;
    if (aniTex != null) {
      shader.setImageSampler(1, aniTex);
    }
    shader.setFloat(2, thickness);
    shader.setFloat(3, borderColor.red.toDouble() / 255);
    shader.setFloat(4, borderColor.green.toDouble() / 255);
    shader.setFloat(5, borderColor.blue.toDouble() / 255);
    shader.setFloat(6, borderColor.opacity);
    shader.setFloat(7, angle);
    shader.setFloat(8, isSelectable ? 1.0 : 0.0);
    return shader;
  }

  static FragmentShader getGreyscaleShader({
    required Rect rect,
    required Image img,
  }) {
    final shader = _shaders[Constants.shaders.greyscale]!.fragmentShader();
    shader.setFloat(0, rect.width);
    shader.setFloat(1, rect.height);
    shader.setFloat(2, rect.left);
    shader.setFloat(3, rect.top);
    shader.setImageSampler(0, img);
    return shader;
  }

  static FragmentShader getColorShader({
    required Rect rect,
    required Image img,
  }) {
    final shader = _shaders[Constants.shaders.color]!.fragmentShader();
    shader.setFloat(0, rect.width);
    shader.setFloat(1, rect.height);
    shader.setFloat(2, rect.left);
    shader.setFloat(3, rect.top);
    shader.setImageSampler(0, img);
    return shader;
  }
}
