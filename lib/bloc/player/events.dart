import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/bloc/game/state.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';

abstract class GameBlocEvent extends BlocEvent {}

class DefeatLeadEvent extends GameBlocEvent {}

class DefeatAceEvent extends GameBlocEvent {}

class SetPlayerUnitEvent extends GameBlocEvent {
  final GameBlocState game;
  final MatchPosition position;
  final Unit unit;
  final int ownerID;
  SetPlayerUnitEvent(
    this.game, {
    required this.position,
    required this.unit,
    required this.ownerID,
  });
}

class ConfirmReplacementEvent extends GameBlocEvent {
  final MatchPosition pos;
  final MatchUnit replacement;
  ConfirmReplacementEvent({
    required this.pos,
    required this.replacement,
  });
}
