import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/models/enums.dart';
import 'package:skygame_2d/models/match_unit/unit_assets_ext.dart';

extension GameReplaceState on GameManager {
  void replaceFrontrow(MatchUnit old, {MatchPosition? inReplacement}) {
    final fieldPos = old.type;

    MatchPosition? replacementPos;
    if (inReplacement != null) {
      replacementPos = inReplacement;
    } else {
      final ll = MatchHelper.getPosRef(old.ownerID, BrawlType.leftLink);
      final rl = MatchHelper.getPosRef(old.ownerID, BrawlType.rightLink);
      switch (fieldPos) {
        case BrawlType.lead:
          if (field[ll] != null && field[rl] != null) {
            state = GameState.replaceSupport;
            return;
          } else if (field[ll] != null) {
            if (field[ll]!.position == MatchPosition.defeated) {
              field[ll] = null;
              state = GameState.replace;
              return;
            } else {
              replacementPos = ll;
            }
          } else if (field[rl] != null) {
            if (field[rl]!.position == MatchPosition.defeated) {
              field[rl] = null;
              state = GameState.replace;
              return;
            } else {
              replacementPos = rl;
            }
          } else {
            final la = MatchHelper.getPosRef(old.ownerID, BrawlType.leftAce);
            final ra = MatchHelper.getPosRef(old.ownerID, BrawlType.rightAce);
            if (field[la] != null &&
                field[la]!.position != MatchPosition.defeated &&
                field[ra] != null &&
                field[ra]!.position != MatchPosition.defeated) {
              state = GameState.replaceWing;
              return;
            } else if (field[la] != null) {
              if (field[la]!.position == MatchPosition.defeated) {
                field[la] = null;
                state = GameState.replace;
                return;
              } else {
                replacementPos = la;
              }
            } else if (field[ra] != null) {
              if (field[ra]!.position == MatchPosition.defeated) {
                field[ra] = null;
                state = GameState.replace;
                return;
              } else {
                replacementPos = ra;
              }
            } else {
              state = GameState.replaceReserve;
              return;
            }
          }
          break;
        case BrawlType.leftAce:
          if (field[ll] != null) {
            replacementPos = ll;
          }
          break;
        case BrawlType.rightAce:
          if (field[rl] != null) {
            replacementPos = rl;
          }
          break;
        default:
          state = GameState.replaceReserve;
          return;
      }
    }

    final replacement = field[replacementPos];
    if (replacement != null && replacement.position != MatchPosition.defeated) {
      replacement.position = old.position;
      MatchUnit? target = field[old.target];
      target ??= field[MatchHelper.getPosRef(
          MatchHelper.getOpponent(old.ownerID), BrawlType.lead)];
      replacement.target = target!.position;
      replacement.asset.refresh();
      field[old.position] = replacement;
    }

    old.position = MatchPosition.defeated;
    old.asset.removeFromGame(GameManager.context);

    if (replacementPos != null) {
      field[replacementPos] = null;
    } else if (replacementPos == null && inReplacement == null) {
      state = GameState.replaceReserve;
    }
    // _clearReplacementStatus(old.ownerID);
  }

  void _clearReplacementStatus(Owner owner) {
    // if (owner == Owner.p1) {
    //   player1.toBeReplaced = null;
    //   player1.confirmedReplacement = null;
    //   player1.state = PlayerState.ready;
    // } else {
    //   player2.toBeReplaced = null;
    //   player2.confirmedReplacement = null;
    //   player2.state = PlayerState.ready;
    // }
  }

  void setReplacement(Owner owner) {
    if (state == GameState.replaceWing) {
      if (owner == Owner.p1) {
        final la = field[MatchPosition.p1LeftAce];
        final ra = field[MatchPosition.p1RightAce];
        // if (la == null && ra == null) {
        //   player1.confirmedReplacement = MatchPosition.none;
        // } else {
        //   player1.confirmedReplacement = Random().nextInt(1) == 0
        //       ? MatchPosition.p1LeftAce
        //       : MatchPosition.p1RightAce;
        // }
      } else {
        final la = field[MatchPosition.p2LeftAce];
        final ra = field[MatchPosition.p2RightAce];
        // if (la == null && ra == null) {
        //   player2.confirmedReplacement = MatchPosition.none;
        // } else {
        //   player2.confirmedReplacement = Random().nextInt(1) == 0
        //       ? MatchPosition.p2LeftAce
        //       : MatchPosition.p2RightAce;
        // }
      }
    } else if (state == GameState.replaceSupport) {
      if (owner == Owner.p1) {
        final ll = field[MatchPosition.p1LeftLink];
        final rl = field[MatchPosition.p1RightLink];
        // if (ll == null && rl == null) {
        //   player1.confirmedReplacement = MatchPosition.none;
        // } else {
        //   player1.confirmedReplacement = Random().nextInt(1) == 0
        //       ? MatchPosition.p1LeftLink
        //       : MatchPosition.p1RightLink;
        // }
      } else {
        final ll = field[MatchPosition.p2LeftLink];
        final rl = field[MatchPosition.p2RightLink];
        // if (ll == null && rl == null) {
        //   player2.confirmedReplacement = MatchPosition.none;
        // } else {
        //   player2.confirmedReplacement = Random().nextInt(1) == 0
        //       ? MatchPosition.p2LeftLink
        //       : MatchPosition.p2RightLink;
        // }
      }
    } else if (state == GameState.replaceReserve) {
      // TODO:
    }
  }
}
