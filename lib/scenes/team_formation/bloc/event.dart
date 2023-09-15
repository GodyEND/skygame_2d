import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';

class ConfirmTFEvent extends BlocEvent {}

class UpdatePlayerFormationEvent extends BlocEvent {
  final List<Unit?> formation;
  final List<Unit> reserve;
  UpdatePlayerFormationEvent(this.formation, this.reserve);
}
