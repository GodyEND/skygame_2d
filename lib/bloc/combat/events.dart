import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

abstract class CombatBlocEvent extends BlocEvent {}

class StartCombatEvent extends CombatBlocEvent {}

class SetupAttackerEvent extends CombatBlocEvent {}

class SimulateCombatEvent extends CombatBlocEvent {
  final MatchUnit attacker;
  final MatchUnit defender;
  SimulateCombatEvent({required this.attacker, required this.defender});
}

class FireCombatAnimationEvent extends CombatBlocEvent {
  final double dt;
  final SkyGame2D game;
  FireCombatAnimationEvent({required this.dt, required this.game});
}

class CombatAnimationEndEvent extends CombatBlocEvent {}

class UpdateExeQEvent extends CombatBlocEvent {
  late List<MatchUnit> exeQ;
  final List<MatchUnit> units;
  final List<MatchUnit> oldQ;
  late List<MatchUnit> sorted;
  UpdateExeQEvent({required this.units, required this.oldQ}) {
    sorted = List<MatchUnit>.from(units);
    sorted.sort((a, b) => b.current.stats[StatType.execution]
        .compareTo(a.current.stats[StatType.execution]));
    exeQ = _next(List.from(oldQ));
  }

  List<MatchUnit> _next(List<MatchUnit> currentQ) {
    if (currentQ.length < 2) {
      currentQ.addAll(sorted);
    }
    currentQ.removeAt(0);
    if (!MatchHelper.isFrontrow(currentQ[0].position)) {
      return _next(currentQ);
    }
    return currentQ;
  }
}
