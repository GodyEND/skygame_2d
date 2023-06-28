import 'dart:math';

import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/simulation.dart';
import 'package:skygame_2d/graphics/animations.dart';
import 'package:skygame_2d/graphics/unit_animations.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/scenes/combat.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

extension GameCombatExt on CombatScene {
  void gameCombat(double dt) {
    switch (combatBloc.state.combatState) {
      case CombatState.attack:
      // if (combatBloc.state.attacker == null && defender == null) {
      //   combatBloc.state.attacker = combatBloc.state.active;
      //   combatBloc.state.defender = MatchHelper.getTarget(game, combatBloc.state.attacker!);

      //   // Validate Wining Condition
      //   if (game.player1ValidateLoss || game.player2ValidateLoss) {
      //     return;
      //   }

      //   combatBloc.state.currentEvent = Simulator.combatEventResult(game);
      //   // game.currentEvent = CombatEventResult.dodge;
      //   AnimationsManager.animateEventText(dt, combatBloc.state.currentEvent);

      //   // Simulate Combat
      //   Simulator.calculateDamage(game,combatBloc.state.attacker!, combatBloc.state.defender!);
      //   Simulator.setCharge(game, combatBloc.state.attacker!, combatBloc.state.defender!);
      //   // TEST DAMAGE
      //   defender!.current.stats.values[StatType.hp] = max(0,
      //       defender!.current.stats[StatType.hp] - defender!.incomingDamage);

      //   attacker!.current.stats.values[StatType.hp] = max(0,
      //       attacker!.current.stats[StatType.hp] - attacker!.incomingDamage);

      //   // Fire Combat Animation
      //   if (attacker!.position != MatchPosition.defeated &&
      //       defender!.position != MatchPosition.defeated) {
      //     attacker!.asset.animationListener.value =
      //         renderCombatAnimation(dt, game.currentEvent, attacker!, true);
      //     defender!.asset.animationListener.value =
      //         renderCombatAnimation(dt, game.currentEvent, defender!, false);
      //     // Prepare Combat Assets
      //     AnimationsManager.prepareCombat(attacker!, defender!);
      //   }
    }

    // Render Stage
    // for (var unit in game.units) {
    //   unit.render(dt);
    // }

    // if ((attacker!.asset.animationState.value == UnitAniState.none ||
    //         attacker!.asset.animationState.value == UnitAniState.idle) &&
    //     (defender!.asset.animationState.value == UnitAniState.none ||
    //         defender!.asset.animationState.value == UnitAniState.idle)) {
    //   attacker = null;
    //   defender = null;
    //   game.updateField(dt);

    //   game.updateActive;
    //   game.cleanup(dt);
    // }
  }
}
