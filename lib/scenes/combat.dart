import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/src/game/flame_game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:skygame_2d/bloc/combat/bloc.dart';
import 'package:skygame_2d/bloc/combat/listener.dart';
import 'package:skygame_2d/game/skygame_ext/game_combat_ext.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/graphics/animations.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/scenes/managed_scene.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

class CombatScene extends ManagedScene {
  late CombatBloc combatBloc;

  @override
  FutureOr<void> onLoad() async {
    combatBloc = CombatBloc();
    await addToScene(FlameMultiBlocProvider(providers: [
      FlameBlocProvider(create: () => combatBloc),
    ]));
    await addToScene(combatBlocListener(game.bloc, combatBloc));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    gameCombat(dt * Constants.ANI_SPEED);

    switch (combatBloc.state.combatState) {
      // case SceneState.replace:
      // if (game.player1.toBeReplaced != null) {
      //   game.replaceFrontrow(game.player1.toBeReplaced!);
      // }
      // if (game.player2.toBeReplaced != null) {
      //   game.replaceFrontrow(game.player2.toBeReplaced!);
      // }
      //break;
      // case SceneState.replaceWing:
      // case SceneState.replaceSupport:
      // if (game.player1.toBeReplaced != null) {
      //   game.setReplacement(Owner.p1);
      //   game.replaceFrontrow(game.player1.toBeReplaced!,
      //       inReplacement: game.player1.confirmedReplacement);
      // }
      // if (game.player2.toBeReplaced != null) {
      //   game.setReplacement(Owner.p2);
      //   game.replaceFrontrow(game.player2.toBeReplaced!,
      //       inReplacement: game.player2.confirmedReplacement);
      // }
      //   break;
      // case SceneState.replaceReserve:
      // if (game.player1.toBeReplaced != null) {
      //   game.replaceFrontrow(game.player1.toBeReplaced!,
      //       inReplacement: MatchPosition.none);
      // }
      // if (game.player2.toBeReplaced != null) {
      //   game.replaceFrontrow(game.player2.toBeReplaced!,
      //       inReplacement: MatchPosition.none);
      // }
      //     break;
      //   case SceneState.end:
      //     print('MATCH ENDED');
      //     break;
      default:
        break;
    }

    // switch (game.state) {
    //   case SceneState.replace:
    //   case SceneState.replaceWing:
    //   case SceneState.replaceSupport:
    //   case SceneState.replaceReserve:
    //     if (game.player1.state == PlayerState.ready &&
    //         game.player2.state == PlayerState.ready) {
    //       game.setBrawlQ;
    //       game.state = SceneState.combat;
    //     }
    //     break;
    //   default:
    //     break;
    // }
  }

  // MatchUnit? attacker;
  // MatchUnit? defender;

  Function() renderCombatAnimation(double dt, CombatEventResult event,
          MatchUnit unit, bool isAttacker) =>
      () => AnimationsManager.animateCombat(dt, event, unit,
          isAttacker: isAttacker);

  //     break;
  //   case CombatState.release:
  //     break;
  //   case CombatState.fx:
  //     break;
  //   case CombatState.swap:
  //     final user = game.active;
  //     final lead =
  //         game.field[MatchHelper.getPosRef(user.owner, BrawlType.lead)]!;

  //     user.currentStats.values[StatType.storage] =
  //         user.currentStats.values[StatType.storage]! -
  //             user.currentCosts[CostType.swap];

  //     // AnimationsManager.prepareSwap(user, lead);
  //     game.updateFieldForSwap(dt, user, lead);

  //     for (var unit in game.units) {
  //       unit.render(dt);
  //     }

  //     break;
  //   case CombatState.retreat:
  //     final user = game.active;
  //     late MatchUnit newActive;
  //     final ll =
  //         game.field[MatchHelper.getPosRef(user.owner, BrawlType.leftLink)]!;
  //     final rl =
  //         game.field[MatchHelper.getPosRef(user.owner, BrawlType.rightLink)]!;
  //     switch (user.type) {
  //       case BrawlType.lead:
  //         newActive = Random().nextInt(2) == 0 ? ll : rl;
  //         break;
  //       case BrawlType.leftAce:
  //         newActive = ll;
  //         break;
  //       case BrawlType.rightLink:
  //         newActive = rl;
  //         break;
  //       default:
  //         return;
  //     }

  //     user.currentStats.values[StatType.storage] =
  //         user.currentStats.values[StatType.storage]! -
  //             user.currentCosts[CostType.retreat];
  //     // AnimationsManager.prepareSwap(user, newActive);
  //     game.updateFieldForSwap(dt, user, newActive);

  //     for (var unit in game.units) {
  //       unit.render(dt);
  //     }

  //     game.cleanup(dt);
  //     break;
  //   default:
  //     break;
  // }
}
