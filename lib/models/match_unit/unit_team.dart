import 'dart:math';

import 'package:skygame_2d/models/match_unit/unit.dart';

class UnitTeam {
  final int id;
  final List<Unit?> _list;
  UnitTeam(this.id, {List<Unit?>? list})
      : _list = list ?? List.filled(10, null);

  operator [](int index) => _list[index];
  operator []=(int index, Unit? unit) => _list[index] = unit;

  List<Unit?> toList() => _list;

  static UnitTeam random(id) {
    final newTeam = UnitTeam(id);
    for (int i = 0; i < 10; i++) {
      newTeam[i] = Random().nextInt(2) == 1 ? Unit.fromRAND() : null;
    }
    return newTeam;
  }
}
