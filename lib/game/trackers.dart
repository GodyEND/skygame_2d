import 'package:skygame_2d/abilities/event.dart';
import 'package:skygame_2d/models/fx.dart';

class FXNotation {
  final int userID;
  final int targetID;
  final FX fx;
  final int turn;
  FXNotation(this.fx, this.userID, this.targetID, this.turn);
}

class EventNotation {
  final int targetID;
  final Event event;
  int turn;
  EventNotation(this.event, this.targetID, this.turn);
}
