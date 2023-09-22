import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

abstract class CombatBlocEvent extends BlocEvent {}

class CombatTurnEndEvent extends CombatBlocEvent {}

class SetExeQEvent extends CombatBlocEvent {
  late List<MatchUnit> exeQ;
  // late List<MatchUnit> prevQ;
  SetExeQEvent(List<MatchUnit> units) {
    // int? lastActiveID;
    exeQ = List<MatchUnit>.from(units);

    // if (units.isNotEmpty) {
    //   lastActiveID = active.id;
    // }
    // brawlQ.clear();
    // brawlQ.addAll(units);
    exeQ.sort((a, b) => b.current.stats[StatType.execution]
        .compareTo(a.current.stats[StatType.execution]));
    // MatchUnit? lastFrontrow;
    // if (lastActiveID != null) {
    //   while (active.id != lastActiveID) {
    //     if (MatchHelper.isFrontrow(active.position)) {
    //       lastFrontrow = active;
    //     }
    //     brawlQ.removeAt(0);
    //   }
    // }
    exeQ.removeWhere((e) => !MatchHelper.isFrontrow(e.position));

    // final prevList = [
    //   lastFrontrow ??
    //       brawlQ.lastWhere((e) => MatchHelper.isFrontrow(e.position))
    // ];
    // prevList.addAll(brawlQ);
    // prevBrawlQ.value = prevList;
  }
}

class UpdateExeQEvent extends CombatBlocEvent {
  late List<MatchUnit> exeQ;
  final List<MatchUnit> units;
  final List<MatchUnit> oldQ;
  late List<MatchUnit> sorted;
  UpdateExeQEvent({required this.units, required this.oldQ}) {
    sorted = List<MatchUnit>.from(units);
    sorted.sort((a, b) => b.current.stats[StatType.execution]
        .compareTo(a.current.stats[StatType.execution]));
    exeQ = _next(oldQ);
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
