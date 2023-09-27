import 'package:skygame_2d/game/trackers.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/models/match_unit/unit_assets_ext.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

class GameManager {
  GameManager();
  // final List<Command> _commandQ = [];

  List<MatchUnit> units = [];

  CombatEventResult currentEvent = CombatEventResult.none;
  List<FXNotation> fxTracker = [];
  List<EventNotation> eventTracker = [];

  // void addToCommandQ(Command command) {
  //   if (!_commandQ.contains(command)) {
  //     _commandQ.add(command);
  //   }
  // }

  void updateFieldForSwap(double dt, MatchUnit user, MatchUnit secondary) {
    final MatchPosition temp = secondary.position;

    // setField(user.ownerID, user.position, null);
    // setField(user.ownerID, secondary.position, null);

    // secondary.position = user.position;
    // user.position = temp;

    // setField(user.ownerID, secondary.position, secondary);
    // setField(user.ownerID, user.position, user);

    // update assets
  }

  void cleanup(double dt) {
    for (var unit in units) {
      unit.asset.refresh();
    }
  }
}
