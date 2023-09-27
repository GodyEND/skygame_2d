import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/layout.dart';
import 'package:skygame_2d/bloc/combat/bloc.dart';
import 'package:skygame_2d/bloc/combat/events.dart';
import 'package:skygame_2d/bloc/combat/listener.dart';
import 'package:skygame_2d/bloc/combat/state.dart';
import 'package:skygame_2d/bloc/key_input/listener.dart';
import 'package:skygame_2d/bloc/player/state.dart';
import 'package:skygame_2d/game/combat_ui/brawl_q.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/stage.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/game_ext/game_combat_ext.dart';
import 'package:skygame_2d/graphics/graphics.dart';
import 'package:skygame_2d/models/player.dart';
import 'package:skygame_2d/scenes/managed_scene.dart';
import 'package:skygame_2d/setup.dart';
import 'package:skygame_2d/utils.dart/constants.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

enum CombatComponentKey {
  queue,
  stage,
  combatEvent;

  String asKey() {
    return 'combat_$name';
  }
}

class CombatScene extends ManagedScene {
  late CombatBloc combatBloc;
  late TextComponent score;
  late List<PlayerBlocState> playerStates;

  @override
  FutureOr<void> onLoad() async {
    final stage = Stage('Arcanelle', Sprites.gMaps[0]);
    playerStates =
        game.playerBlocs.map<PlayerBlocState>((e) => e.state).toList();
    combatBloc = CombatBloc(
        initialState: InitialCombatBlocState(
      players: game.playerBlocs.map<Player>((e) => e.state.player).toList(),
      playerStates: playerStates,
      stage: stage,
    ));
    managedBloc = combatBloc;
    for (var playerBloc in game.playerBlocs) {
      await addToScene(game.keyBlocListener(
          playerBloc.state.keyBloc, playerBloc, combatBloc));
    }
    await addToScene(combatBlocListener(game.bloc, combatBloc));

    // Stage
    await addToScene(GraphicsManager.createStage(stage.bg));
    // HUD & Units
    List<MapEntry<MatchPosition, MatchUnit?>> units = [];

    for (var entry in combatBloc.state.field.values.toList()) {
      units.addAll(entry.entries.toList());
    }
    for (var posMap in units) {
      if (MatchHelper.isField(posMap.key) && posMap.value != null) {
        await addToScene(posMap.value!.asset.sprite);
        await addToScene(posMap.value!.asset.hud);
      }
    }

    await addToScene(GraphicsManager.createScoreHUDText()
      ..text = '${playerStates[0].points} : ${playerStates[1].points}');
    await addToScene(BrawlQComponent(
      combatBloc.state.exeQ,
      key: ComponentKey.named(CombatComponentKey.queue.asKey()),
    ));

    await addToScene(GraphicsManager.createEventText(
        ComponentKey.named(CombatComponentKey.combatEvent.asKey())));

    combatBloc.add(StartCombatEvent());
  }

  @override
  void update(double dt) {
    super.update(dt);
    gameCombat(dt * Constants.ANI_SPEED);

    //   final queueComp =
    //       game.findByKeyName<BrawlQComponent>(CombatComponentKey.queue.asKey());
    //   queueComp?.animatedQ.value = combatBloc.state.exeQ;

    // switch (combatBloc.state.combatState) {
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
    //   default:
    //     break;
    // }

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

  // Function() renderCombatAnimation(double dt, CombatEventResult event,
  //         MatchUnit unit, bool isAttacker) =>
  //     () => AnimationsManager.animateCombat(dt, event, unit,
  //         isAttacker: isAttacker);

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
