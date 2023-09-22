import 'package:flame/components.dart';
import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

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

  static MatchUnit getTarget(GameManager game, MatchUnit attacker) {
    final opponentID = MatchHelper.getOpponent(attacker.ownerID);
    var currentTarget = GameManager.field(opponentID)[attacker.target];
    if (currentTarget == null ||
        currentTarget.position == MatchPosition.defeated) {
      const newTargetPos = MatchPosition.lead;
      currentTarget = GameManager.field(opponentID)[newTargetPos];
      attacker.target = newTargetPos;
    }
    return currentTarget!;
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

  static int getOpponent(int ownerID) {
    return ownerID == 1 ? Constants.SECOND_PLAYER : Constants.FIRST_PLAYER;
  }

  static bool remove(SkyGame2D gameContext, Component c) {
    if (gameContext.contains(c)) {
      gameContext.remove(c);
      return true;
    }
    return false;
  }

  static bool removeAll(SkyGame2D gameContext, List<Component> cList) {
    List<bool> hasRemoved = [];
    for (var c in cList) {
      hasRemoved.add(remove(gameContext, c));
    }
    return hasRemoved.contains(true);
  }

  static List<MatchUnit> getOpposingUnits(int ownerID) {
    List<MatchUnit?> opponents = [];
    final opponentID = (ownerID == Constants.FIRST_PLAYER)
        ? Constants.SECOND_PLAYER
        : Constants.FIRST_PLAYER;
    opponents.add(GameManager.field(opponentID)[MatchPosition.lead]);
    opponents.add(GameManager.field(opponentID)[MatchPosition.leftAce]);
    opponents.add(GameManager.field(opponentID)[MatchPosition.rightAce]);
    opponents.add(GameManager.field(opponentID)[MatchPosition.leftLink]);
    opponents.add(GameManager.field(opponentID)[MatchPosition.rightLink]);
    return List<MatchUnit>.from(opponents.where((e) => e != null).toList());
  }

  static int getUnitPoints(MatchPosition type) {
    switch (type) {
      case MatchPosition.lead:
        return 2;
      case MatchPosition.leftAce:
      case MatchPosition.rightAce:
        return 1;
      default:
        return 0;
    }
  }
}
