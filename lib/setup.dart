import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:skygame_2d/graphics/graphics.dart';

class Sprites {
  static final Map<String, Image> _list = {};

  static Future<bool> loadImages() async {
    try {
      for (int i = 1; i <= 5; i++) {
        final filepath = 'angelos_$i$PF_SPRITE.png';
        _list[filepath] = await Flame.images.load(filepath);
      }
      for (int i = 1; i <= 5; i++) {
        final filepath = 'angelos_$i$PF_PROFILE.png';
        _list[filepath] = await Flame.images.load(filepath);
      }
      for (int i = 1; i <= 5; i++) {
        final filepath = 'angelos_$i$PF_SELECT.png';
        _list[filepath] = await Flame.images.load(filepath);
      }
      for (int i = 1; i <= 1; i++) {
        final filepath = 'map_$i.png';
        _list[filepath] = await Flame.images.load(filepath);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  static Image q(String query) {
    // TODO: error handling
    return Flame.images.fromCache('$query.png');
  }

  static List<Image> get gChar => List<Image>.from(_list.entries
      .map<Image?>((entry) => !entry.key.contains('map_') ? entry.value : null)
      .where((e) => e != null)
      .toList());

  static List<Image> get gMaps => List<Image>.from(_list.entries
      .map<Image?>((entry) => entry.key.contains('map_') ? entry.value : null)
      .where((e) => e != null)
      .toList());
}
