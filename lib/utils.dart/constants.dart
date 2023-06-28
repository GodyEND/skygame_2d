// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flame/components.dart';

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
}
