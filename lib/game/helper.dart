import 'package:skygame_2d/scenes/combat/bloc/combat/state.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/utils.dart/constants.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

class MatchHelper {
  static MatchPosition getDefaultTarget(MatchPosition position) {
    switch (position) {
      case MatchPosition.lead:
        return MatchPosition.lead;
      case MatchPosition.leftAce:
        return MatchPosition.rightAce;
      case MatchPosition.rightAce:
        return MatchPosition.leftAce;
      default:
        return MatchPosition.none;
    }
  }

  static MatchUnit getTarget(
      MatchUnit attacker, Map<int, Map<MatchPosition, MatchUnit?>> field) {
    final opponentID = getOpponent(attacker.ownerID);
    var currentTarget = field[opponentID]?[attacker.target];
    if (currentTarget == null ||
        currentTarget.position == MatchPosition.defeated) {
      const newTargetPos = MatchPosition.lead;
      currentTarget = field[opponentID]?[newTargetPos];
      attacker.target = newTargetPos;
    }

    return currentTarget ?? field[opponentID]![MatchPosition.lead]!;
  }

  static List<MatchPosition> getLinkRef(MatchPosition position) {
    switch (position) {
      case MatchPosition.leftLink:
        return [MatchPosition.lead, MatchPosition.leftAce];
      case MatchPosition.rightLink:
        return [MatchPosition.lead, MatchPosition.rightAce];
      default:
        return [];
    }
  }

  static bool isLeftTeam(MatchUnit unit) {
    return unit.ownerID == Constants.FIRST_PLAYER;
  }

  static bool isFrontrow(MatchPosition type) {
    return (type == MatchPosition.lead ||
        type == MatchPosition.leftAce ||
        type == MatchPosition.rightAce);
  }

  static bool isField(MatchPosition type) {
    return (type == MatchPosition.lead ||
        type == MatchPosition.leftAce ||
        type == MatchPosition.rightAce ||
        type == MatchPosition.leftLink ||
        type == MatchPosition.rightLink);
  }

  static bool hasReserve(Map<MatchPosition, MatchUnit?> map) {
    bool hasReserve = false;
    for (var unit in map.values.toList()) {
      if (unit == null) continue;
      if (!MatchHelper.isField(unit.position) &&
          unit.position != MatchPosition.defeated) {
        hasReserve = true;
        break;
      }
    }
    return hasReserve;
  }

  static int getOpponent(int ownerID) {
    return ownerID == 1 ? Constants.SECOND_PLAYER : Constants.FIRST_PLAYER;
  }

  static List<MatchUnit> getUnits(int ownerID, CombatBlocState state) {
    List<MatchUnit?> result = [];

    result.add(state.field[ownerID]?[MatchPosition.lead]);
    result.add(state.field[ownerID]?[MatchPosition.leftAce]);
    result.add(state.field[ownerID]?[MatchPosition.rightAce]);
    result.add(state.field[ownerID]?[MatchPosition.leftLink]);
    result.add(state.field[ownerID]?[MatchPosition.rightLink]);
    return List<MatchUnit>.from(result.where((e) => e != null).toList());
  }

  static List<MatchUnit> getOpposingUnits(int ownerID, CombatBlocState state) {
    final opponentID = (ownerID == Constants.FIRST_PLAYER)
        ? Constants.SECOND_PLAYER
        : Constants.FIRST_PLAYER;
    return getUnits(opponentID, state);
  }

  // static int getUnitPoints(MatchPosition type) {
  //   switch (type) {
  //     case MatchPosition.lead:
  //       return 2;
  //     case MatchPosition.leftAce:
  //     case MatchPosition.rightAce:
  //       return 1;
  //     default:
  //       return 0;
  //   }
  // }
}
