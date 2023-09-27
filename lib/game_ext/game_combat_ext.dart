import 'package:skygame_2d/bloc/combat/events.dart';
import 'package:skygame_2d/scenes/combat.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

extension GameCombatExt on CombatScene {
  void gameCombat(double dt) {
    switch (combatBloc.state.combatState) {
      case CombatState.attack:
        if (combatBloc.state.event is SimulateCombatEvent) {
          combatBloc.add(FireCombatAnimationEvent(dt: dt, game: game));
        }
        break;
      default:
        break;

      // if (combatBloc.state.attacker == null && defender == null) {
      //   combatBloc.state.attacker = combatBloc.state.active;
      //   combatBloc.state.defender = MatchHelper.getTarget(game, combatBloc.state.attacker!);

      //   // Validate Wining Condition
      //   if (game.player1ValidateLoss || game.player2ValidateLoss) {
      //     return;
      //   }

      //   AnimationsManager.animateEventText(dt, combatBloc.state.currentEvent);

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
