import 'dart:math';
import 'dart:ui';
import 'package:skygame_2d/characters/angelos/angelos.dart';
import 'package:skygame_2d/models/bes.dart';
import 'package:skygame_2d/models/costs.dart';
import 'package:skygame_2d/models/enums.dart';
import 'package:skygame_2d/models/fx.dart';
import 'package:skygame_2d/models/release.dart';
import 'package:skygame_2d/models/stats.dart';

abstract class Unit {
  final String name;
  final Element element;
  final Species species;
  final Image image;
  final Image profile;
  final Stats stats;
  final Release release;
  final FX fx;
  final BES bes;
  final Costs costs;

  Unit({
    required this.name,
    required this.element,
    required this.species,
    required this.image,
    required this.profile,
    required this.stats,
    required this.release,
    required this.fx,
    required this.bes,
    required this.costs,
  }) {
    Units.add(this);
  }

  factory Unit.fromRAND() => Units.rand();
}

/// MARK: Brawl Manager
class Units {
  static final List<Unit> _list = [];
  static Unit q(String query) {
    return _list.where((q) => q.name == query).first;
  }

  static Unit rand() {
    final rng = Random();
    final result = rng.nextInt(_list.length);
    return _list[result];
  }

  static void add(Unit r) {
    if (!_list.contains(r)) _list.add(r);
  }

  static get load {
    Angelos1();
    Angelos2();
    Angelos3();
    Angelos4();
    Angelos5();
  }

  static int get number => _list.length;
}
