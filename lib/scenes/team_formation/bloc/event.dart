import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';

class ConfirmTFEvent extends BlocEvent {
  int ownerID;
  ConfirmTFEvent(this.ownerID);
}

class UpdatePlayerFormationEvent extends BlocEvent {
  final List<Unit?> formation;
  final List<Unit?> reserve;
  UpdatePlayerFormationEvent(this.formation, List<Unit> reserve)
      : reserve = _generateReserve(reserve);
}

List<Unit?> _generateReserve(List<Unit> reserve) {
  final result = List<Unit?>.filled(10, null);
  for (int i = 0; i < reserve.length; i++) {
    result[i] = reserve[i];
  }
  return result;
}
