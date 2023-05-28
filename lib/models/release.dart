import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/models/enums.dart';
import 'package:skygame_2d/abilities/release.dart';

abstract class Release {
  final String name;
  final String text;
  final ReleaseType type;
  final double damage;
  void action(MatchUnit user, GameManager game);

  Release(
    this.name, {
    required this.type,
    required this.text,
    this.damage = 0,
  }) {
    Releases.add(this);
  }
}

/// MARK: Release Manager
class Releases {
  static final List<Release> _list = [];
  static Release q(String query) {
    return _list.where((q) => q.name == query).first;
  }

  static void add(Release r) {
    if (!_list.contains(r)) _list.add(r);
  }

  static get load {
    Release1();
    Release2();
    Release3();
    Release4();
    Release5();
  }
}
