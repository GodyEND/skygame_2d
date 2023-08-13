// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class Constants {
  static const double SCREEN_WIDTH = 1920;
  static const double SCREEN_HEIGHT = 1080;
  static Vector2 get SCREEN_CENTER =>
      Vector2(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);

  static const int HUD_TEXT_PRIORITY = 10;
  // Team Builder settings
  static const int TEAM_BUILDER_UNITS_PER_ROW = 4;
  // Combat settings
  static const int PLAYER_COUNT = 2;
  static const int COMBAT_Q_LENGTH = 7;
  static const int ANI_SPEED = 1;
  static const int BASE_DAMAGE = 50;
  // Combat References
  static const int FIRST_PLAYER = 1;
  static const int SECOND_PLAYER = 2;

  static ShaderPaths shaders = ShaderPaths();
  static TextureImages images = TextureImages();
}

class ShaderPaths {
  static const String _dir = 'assets/shaders';
  final String color = '$_dir/color.frag';
  final String outline = '$_dir/outline.frag';
  final String greyscale = '$_dir/greyscale.frag';
}

class TextureImages {
  static const String _dir = 'assets/images';

  Image? outlineTex;
  Image? unitTeamBG;
  TextureImages() {
    init();
  }

  Future<void> init() async {
    final data = await rootBundle.load('$_dir/outline_tex.png');
    outlineTex = await loadImage(Uint8List.view(data.buffer));
    final data2 = await rootBundle.load('$_dir/unit_team_bg.png');
    unitTeamBG = await loadImage(Uint8List.view(data2.buffer));
  }

  Future<Image> loadImage(Uint8List img) async {
    final Completer<Image> imageCompleter = Completer();
    decodeImageFromList(img, (Image img) {
      imageCompleter.complete(img);
    });
    return imageCompleter.future;
  }
}
