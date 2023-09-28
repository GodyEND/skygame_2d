import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

// extension GameReplaceState on GameManager {
//   void replaceFrontrow(MatchUnit old, {MatchPosition? inReplacement}) {
//     final fieldPos = old.position;

    // MatchPosition? replacementPos;
    // if (inReplacement != null) {
    //   replacementPos = inReplacement;
    // } else {
    //   final ll = GameManager.field(old.ownerID)[MatchPosition.leftLink];
    //   final rl = GameManager.field(old.ownerID)[MatchPosition.rightLink];
    //   switch (fieldPos) {
    //     case MatchPosition.lead:
    //       if (ll != null && rl != null) {
    //         // state = SceneState.replaceSupport;
    //         return;
    //       } else if (ll != null) {
    //         if (ll.position == MatchPosition.defeated) {
    //           GameManager.setField(old.ownerID, MatchPosition.leftLink, null);
    //           // state = SceneState.replace;
    //           return;
    //         } else {
    //           replacementPos = ll.position;
    //         }
    //       } else if (rl != null) {
    //         if (rl.position == MatchPosition.defeated) {
    //           GameManager.setField(old.ownerID, MatchPosition.rightLink, null);
    //           // state = SceneState.replace;
    //           return;
    //         } else {
    //           replacementPos = rl.position;
    //         }
    //       } else {
    //         final la = GameManager.field(old.ownerID)[MatchPosition.leftAce];
    //         final ra = GameManager.field(old.ownerID)[MatchPosition.rightAce];
    //         if (la != null &&
    //             la.position != MatchPosition.defeated &&
    //             ra != null &&
    //             ra.position != MatchPosition.defeated) {
    //           // state = SceneState.replaceWing;
    //           return;
    //         } else if (la != null) {
    //           if (la.position == MatchPosition.defeated) {
    //             GameManager.setField(old.ownerID, MatchPosition.leftAce, null);
    //             // state = SceneState.replace;
    //             return;
    //           } else {
    //             replacementPos = la.position;
    //           }
    //         } else if (ra != null) {
    //           if (ra.position == MatchPosition.defeated) {
    //             GameManager.setField(old.ownerID, MatchPosition.rightAce, null);
    //             // state = SceneState.replace;
    //             return;
    //           } else {
    //             replacementPos = ra.position;
    //           }
    //         } else {
    //           // state = SceneState.replaceReserve;
    //           return;
    //         }
    //       }
    //       break;
    //     case MatchPosition.leftAce:
    //       if (ll != null) {
    //         replacementPos = ll.position;
    //       }
    //       break;
    //     case MatchPosition.rightAce:
    //       if (rl != null) {
    //         replacementPos = rl.position;
    //       }
    //       break;
    //     default:
    //       // state = SceneState.replaceReserve;
    //       return;
    //   }
    // }

    // final replacement = GameManager.field(old.ownerID)[replacementPos];
    // if (replacement != null && replacement.position != MatchPosition.defeated) {
    //   replacement.position = old.position;
    //   MatchUnit? target = GameManager.field(old.ownerID)[old.target];
    //   target ??= GameManager.field(old.ownerID)[MatchPosition.lead];
    //   replacement.target = target!.position;
    //   replacement.asset.refresh();
    //   GameManager.field(old.ownerID)[old.position] = replacement;
    // }

    // old.position = MatchPosition.defeated;
    // // old.asset.removeFromGame(GameManager.context);

    // if (replacementPos != null) {
    //   GameManager.field(old.ownerID)[replacementPos] = null;
    // } else if (replacementPos == null && inReplacement == null) {
    //   // state = SceneState.replaceReserve;
    // }
    // _clearReplacementStatus(old.ownerID);
  // }

  // void _clearReplacementStatus(int ownerID) {
    // if (owner == Owner.p1) {
    //   player1.toBeReplaced = null;
    //   player1.confirmedReplacement = null;
    //   player1.state = PlayerState.ready;
    // } else {
    //   player2.toBeReplaced = null;
    //   player2.confirmedReplacement = null;
    //   player2.state = PlayerState.ready;
    // }
  // }

  // void setReplacement(ownerID) {
    // if (state == SceneState.replaceWing) {
    //   final la = GameManager.field(ownerID)[MatchPosition.leftAce];
    //   final ra = GameManager.field(ownerID)[MatchPosition.rightAce];
    //   // if (la == null && ra == null) {
    //   //   player1.confirmedReplacement = MatchPosition.none;
    //   // } else {
    //   //   player1.confirmedReplacement = Random().nextInt(1) == 0
    //   //       ? MatchPosition.p1LeftAce
    //   //       : MatchPosition.p1RightAce;
    //   // }
    // } else if (state == SceneState.replaceSupport) {
    //   final ll = GameManager.field(ownerID)[MatchPosition.leftLink];
    //   final rl = GameManager.field(ownerID)[MatchPosition.rightLink];
    //   // if (ll == null && rl == null) {
    //   //   player1.confirmedReplacement = MatchPosition.none;
    //   // } else {
    //   //   player1.confirmedReplacement = Random().nextInt(1) == 0
    //   //       ? MatchPosition.p1LeftLink
    //   //       : MatchPosition.p1RightLink;
    //   // }
    // } else if (state == SceneState.replaceReserve) {
    //   // TODO:
    // }
//   }
// }
