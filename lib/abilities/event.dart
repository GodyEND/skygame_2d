import 'dart:math';

import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/models/enums.dart';

abstract class Event {
  final String desc;
  Event({required this.desc});

  void action(MatchUnit target, GameManager game);
}

class Burn extends Event {
  Burn() : super(desc: 'deals 6% of damage to the target');

  @override
  void action(MatchUnit target, GameManager game) {
    target.current.stats.values[StatType.hp] = max(
        0.0,
        target.current.stats[StatType.hp] -
            target.initial.stats[StatType.hp] * 0.06);
    final event = target.eventQ.firstWhere((e) => e.event is Burn);
    event.turn = max(0, event.turn - 1);
    if (event.turn == 0) {
      target.eventQ.remove(event);
    }
  }
}
