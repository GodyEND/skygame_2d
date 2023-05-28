import 'package:flame/components.dart';
import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/models/enums.dart';

class MatchHelper {
  static MatchPosition getPosRef(Owner owner, BrawlType type) {
    switch (owner) {
      case Owner.p1:
        switch (type) {
          case BrawlType.lead:
            return MatchPosition.p1Lead;
          case BrawlType.leftAce:
            return MatchPosition.p1LeftAce;
          case BrawlType.rightAce:
            return MatchPosition.p1RightAce;
          case BrawlType.leftLink:
            return MatchPosition.p1LeftLink;
          case BrawlType.rightLink:
            return MatchPosition.p1RightLink;
          case BrawlType.reserve1:
          case BrawlType.reserve2:
          case BrawlType.reserve3:
          case BrawlType.reserve4:
          case BrawlType.reserve5:
            return MatchPosition.p1Reserve;
          case BrawlType.defeated:
            return MatchPosition.defeated;
        }
      default:
        switch (type) {
          case BrawlType.lead:
            return MatchPosition.p2Lead;
          case BrawlType.leftAce:
            return MatchPosition.p2LeftAce;
          case BrawlType.rightAce:
            return MatchPosition.p2RightAce;
          case BrawlType.leftLink:
            return MatchPosition.p2LeftLink;
          case BrawlType.rightLink:
            return MatchPosition.p2RightLink;
          case BrawlType.reserve1:
          case BrawlType.reserve2:
          case BrawlType.reserve3:
          case BrawlType.reserve4:
          case BrawlType.reserve5:
            return MatchPosition.p2Reserve;
          case BrawlType.defeated:
            return MatchPosition.defeated;
        }
    }
  }

  static BrawlType getBrawlType(MatchPosition position) {
    switch (position) {
      case MatchPosition.p1Lead:
      case MatchPosition.p2Lead:
        return BrawlType.lead;
      case MatchPosition.p1LeftAce:
      case MatchPosition.p2LeftAce:
        return BrawlType.leftAce;
      case MatchPosition.p1RightAce:
      case MatchPosition.p2RightAce:
        return BrawlType.rightAce;
      case MatchPosition.p1LeftLink:
      case MatchPosition.p2LeftLink:
        return BrawlType.leftLink;
      case MatchPosition.p1RightLink:
      case MatchPosition.p2RightLink:
        return BrawlType.rightLink;
      case MatchPosition.defeated:
        return BrawlType.defeated;
      default:
        return BrawlType.reserve1;
    }
  }

  static MatchPosition getDefaultTarget(MatchPosition position) {
    final fieldPos = MatchHelper.getBrawlType(position);
    late BrawlType target;
    switch (fieldPos) {
      case BrawlType.lead:
        target = BrawlType.lead;
        break;
      case BrawlType.leftAce:
        target = BrawlType.rightAce;
        break;
      case BrawlType.rightAce:
        target = BrawlType.leftAce;
        break;
      default:
        return MatchPosition.none;
    }
    return getPosRef(
        MatchHelper.getOpponent(MatchHelper.getOwner(position)), target);
  }

  static MatchUnit getTarget(GameManager game, MatchUnit attacker) {
    var currentTarget = game.field[attacker.target];
    if (currentTarget == null ||
        currentTarget.position == MatchPosition.defeated) {
      final newTargetPos = MatchHelper.getPosRef(
          MatchHelper.getOpponent(attacker.owner), BrawlType.lead);
      currentTarget = game.field[newTargetPos];
      attacker.target = newTargetPos;
    }
    // if (currentTarget!.position == MatchPosition.defeated) {
    //   game.state == GameState.end;
    // }
    return currentTarget!;
  }

  static List<MatchPosition> getLinkRef(Owner owner, BrawlType position) {
    switch (owner) {
      case Owner.p1:
        switch (position) {
          case BrawlType.leftLink:
            return [MatchPosition.p1Lead, MatchPosition.p1LeftAce];
          case BrawlType.rightLink:
            return [MatchPosition.p1Lead, MatchPosition.p1RightAce];
          default:
            return [];
        }
      default:
        switch (position) {
          case BrawlType.leftLink:
            return [MatchPosition.p2Lead, MatchPosition.p2LeftAce];
          case BrawlType.rightLink:
            return [MatchPosition.p2Lead, MatchPosition.p2RightAce];
          default:
            return [];
        }
    }
  }

  static bool isFrontrow(BrawlType type) {
    return (type == BrawlType.lead ||
        type == BrawlType.leftAce ||
        type == BrawlType.rightAce);
  }

  static Owner getOwner(MatchPosition position) {
    return (position.name.contains('p1')) ? Owner.p1 : Owner.p2;
  }

  static Owner getOpponent(Owner owner) {
    return owner == Owner.p1 ? Owner.p2 : Owner.p1;
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

  static List<MatchUnit> getOpposingUnits(
      Map<MatchPosition, MatchUnit?> field, Owner owner) {
    List<MatchUnit?> opponents = [];
    switch (owner) {
      case Owner.p1:
        opponents.add(field[MatchPosition.p2Lead]);
        opponents.add(field[MatchPosition.p2LeftAce]);
        opponents.add(field[MatchPosition.p2RightAce]);
        opponents.add(field[MatchPosition.p2LeftLink]);
        opponents.add(field[MatchPosition.p2RightLink]);
        break;
      default:
        opponents.add(field[MatchPosition.p1Lead]);
        opponents.add(field[MatchPosition.p1LeftAce]);
        opponents.add(field[MatchPosition.p1RightAce]);
        opponents.add(field[MatchPosition.p1LeftLink]);
        opponents.add(field[MatchPosition.p1RightLink]);
        break;
    }
    return List<MatchUnit>.from(opponents.where((e) => e != null).toList());
  }

  static int getUnitPoints(BrawlType type) {
    switch (type) {
      case BrawlType.lead:
        return 2;
      case BrawlType.leftAce:
      case BrawlType.rightAce:
        return 1;
      default:
        return 0;
    }
  }
}
