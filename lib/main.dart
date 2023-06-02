import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skygame_2d/game/combat_ui/brawl_q.dart';
import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/game/game_ext.dart';
import 'package:skygame_2d/game/game_input_ext.dart';
import 'package:skygame_2d/game/game_replacement_ext.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/simulation.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/graphics/animations.dart';
import 'package:skygame_2d/graphics/graphics.dart';
import 'package:skygame_2d/graphics/unit_animations.dart';
import 'package:skygame_2d/models/enums.dart';
import 'package:skygame_2d/models/fx.dart';
import 'package:skygame_2d/models/release.dart';
import 'package:skygame_2d/models/unit.dart';
import 'package:skygame_2d/setup.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GameWidget(game: SkyGame2D()));
}

class SkyGame2D extends FlameGame with KeyboardEvents {
  late GameManager game;

  @override
  Future<void> onLoad() async {
    Constants.setSCREEN_WIDTH(size.x);
    await setup();
  }

  @override
  void handleResize(Vector2 size) {
    // ignore: invalid_use_of_internal_member
    super.handleResize(size);
    Constants.setSCREEN_WIDTH(size.x);
    // Add refresh method to render objects
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    switch (game.state) {
      case GameState.combat:
        final p1KeyHandled = game.player1Input(event, keysPressed);
        final p2KeyHandled = game.player2Input(event, keysPressed);
        if (p1KeyHandled || p2KeyHandled) {
          return KeyEventResult.handled;
        }
        break;
      case GameState.replaceWing:
        break;
      case GameState.replaceSupport:
        break;
      case GameState.replaceReserve:
        break;
      default:
        break;
    }
    return KeyEventResult.ignored;
  }

  Future<void> setup() async {
    // Load Image files
    await Sprites.loadImages();

    // Load Game Data
    Releases.load;
    FXs.load;
    Units.load;

    game = GameManager(this);
    game.state = GameState.setup;
  }

  @override
  void update(double dt) {
    super.update(dt);

    switch (game.state) {
      case GameState.setup:
        _setup();
        break;
      case GameState.combat:
        _renderCombat(dt * Constants.ANI_SPEED);
        break;
      case GameState.replace:
        if (game.player1.toBeReplaced != null) {
          game.replaceFrontrow(game.player1.toBeReplaced!);
        }
        if (game.player2.toBeReplaced != null) {
          game.replaceFrontrow(game.player2.toBeReplaced!);
        }
        break;
      case GameState.replaceWing:
      case GameState.replaceSupport:
        if (game.player1.toBeReplaced != null) {
          game.setReplacement(Owner.p1);
          game.replaceFrontrow(game.player1.toBeReplaced!,
              inReplacement: game.player1.confirmedReplacement);
        }
        if (game.player2.toBeReplaced != null) {
          game.setReplacement(Owner.p2);
          game.replaceFrontrow(game.player2.toBeReplaced!,
              inReplacement: game.player2.confirmedReplacement);
        }
        break;
      case GameState.replaceReserve:
        if (game.player1.toBeReplaced != null) {
          game.replaceFrontrow(game.player1.toBeReplaced!,
              inReplacement: MatchPosition.none);
        }
        if (game.player2.toBeReplaced != null) {
          game.replaceFrontrow(game.player2.toBeReplaced!,
              inReplacement: MatchPosition.none);
        }
        break;
      case GameState.end:
        print('MATCH ENDED');
        break;
      default:
        break;
    }

    switch (game.state) {
      case GameState.replace:
      case GameState.replaceWing:
      case GameState.replaceSupport:
      case GameState.replaceReserve:
        if (game.player1.state == PlayerState.ready &&
            game.player2.state == PlayerState.ready) {
          game.setBrawlQ;
          game.state = GameState.combat;
        }
        break;
      default:
        break;
    }
  }

  void _setup() {
    // Generate Stage Sprites
    GraphicsManager.prepareStageAssets;
    add(GameManager.spriteList['0$PF_BG']!);
    add(GameManager.spriteList[EVENT_TEXT]!);
    add(GameManager.spriteList[SCORE_TEXT]!);
    // Prepare Match
    game.setup();
    add(BrawlQComponent(game, game.prevBrawlQ));
  }

  MatchUnit? attacker;
  MatchUnit? defender;

  Function() renderCombatAnimation(double dt, CombatEventResult event,
          MatchUnit unit, bool isAttacker) =>
      () => AnimationsManager.animateCombat(dt, event, unit,
          isAttacker: isAttacker);

  void _renderCombat(double dt) {
    switch (game.combatState) {
      case CombatState.attack:
        if (attacker == null && defender == null) {
          attacker = game.active;
          defender = MatchHelper.getTarget(game, attacker!);

          // Validate Wining Condition
          if (game.player1ValidateLoss || game.player2ValidateLoss) {
            return;
          }
          game.currentEvent = Simulator.combatEventResult(game);
          // game.currentEvent = CombatEventResult.dodge;
          AnimationsManager.animateEventText(dt, game.currentEvent);

          // Simulate Combat
          Simulator.calculateDamage(game, attacker!, defender!);
          Simulator.setCharge(game, attacker!, defender!);
          // TEST DAMAGE
          defender!.currentStats.values[StatType.hp] = max(0,
              defender!.currentStats[StatType.hp] - defender!.incomingDamage);

          attacker!.currentStats.values[StatType.hp] = max(0,
              attacker!.currentStats[StatType.hp] - attacker!.incomingDamage);

          // Fire Combat Animation
          if (attacker!.position != MatchPosition.defeated &&
              defender!.position != MatchPosition.defeated) {
            attacker!.asset.animationListener.value =
                renderCombatAnimation(dt, game.currentEvent, attacker!, true);
            defender!.asset.animationListener.value =
                renderCombatAnimation(dt, game.currentEvent, defender!, false);
            // Prepare Combat Assets
            AnimationsManager.prepareCombat(attacker!, defender!);
          }
        }

        // Render Stage
        for (var unit in game.units) {
          unit.render(dt);
        }

        if ((attacker!.asset.animationState.value == UnitAniState.none ||
                attacker!.asset.animationState.value == UnitAniState.idle) &&
            (defender!.asset.animationState.value == UnitAniState.none ||
                defender!.asset.animationState.value == UnitAniState.idle)) {
          attacker = null;
          defender = null;
          game.updateField(dt);

          game.updateActive;
          game.cleanup(dt);
        }
        break;
      case CombatState.release:
        break;
      case CombatState.fx:
        break;
      case CombatState.swap:
        final user = game.active;
        final lead =
            game.field[MatchHelper.getPosRef(user.owner, BrawlType.lead)]!;

        user.currentStats.values[StatType.storage] =
            user.currentStats.values[StatType.storage]! -
                user.currentCosts[CostType.swap];

        // AnimationsManager.prepareSwap(user, lead);
        game.updateFieldForSwap(dt, user, lead);

        for (var unit in game.units) {
          unit.render(dt);
        }

        break;
      case CombatState.retreat:
        final user = game.active;
        late MatchUnit newActive;
        final ll =
            game.field[MatchHelper.getPosRef(user.owner, BrawlType.leftLink)]!;
        final rl =
            game.field[MatchHelper.getPosRef(user.owner, BrawlType.rightLink)]!;
        switch (user.type) {
          case BrawlType.lead:
            newActive = Random().nextInt(2) == 0 ? ll : rl;
            break;
          case BrawlType.leftAce:
            newActive = ll;
            break;
          case BrawlType.rightLink:
            newActive = rl;
            break;
          default:
            return;
        }

        user.currentStats.values[StatType.storage] =
            user.currentStats.values[StatType.storage]! -
                user.currentCosts[CostType.retreat];
        // AnimationsManager.prepareSwap(user, newActive);
        game.updateFieldForSwap(dt, user, newActive);

        for (var unit in game.units) {
          unit.render(dt);
        }

        game.cleanup(dt);

        break;
      default:
        break;
    }
  }
}
