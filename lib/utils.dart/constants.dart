import 'package:flame/components.dart';

class Constants {
  static double _screen_width = 1920;
// Application settings
  static void setSCREEN_WIDTH(double value) {
    _screen_width = value;
  }

  static double get SCREEN_WIDTH => _screen_width;
  static double get SCREEN_HEIGHT => _screen_width * 9 / 16;
  static Vector2 get SCREEN_CENTER =>
      Vector2(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
// Combat settings
  static const int COMBAT_Q_LENGTH = 7;
  static const int ANI_SPEED = 1;
  static const int BASE_DAMAGE = 50;
}
