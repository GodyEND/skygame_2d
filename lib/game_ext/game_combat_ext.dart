import 'package:skygame_2d/scenes/combat/bloc/combat/events.dart';
import 'package:skygame_2d/scenes/combat/bloc/replace/state.dart';
import 'package:skygame_2d/scenes/combat/combat.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

extension GameCombatExt on CombatScene {
  void gameCombat(double dt) {
    switch (combatBloc.state.combatState) {
      case CombatState.attack:
        if (combatBloc.state.event is SimulateCombatEvent) {
          combatBloc.add(FireCombatAnimationEvent(dt: dt, game: game));
        }
        break;
      case CombatState.replace:
        // Validate return to combat
        final p1ReplaceState = combatBloc.state.replaceBlocs[0].state;
        final p2ReplaceState = combatBloc.state.replaceBlocs[1].state;
        if (p1ReplaceState.event is ValidateReadyReplaceBlocState ||
            p2ReplaceState.event is ValidateReadyReplaceBlocState) {
          if (p1ReplaceState.viewState == PlayerState.ready &&
              p2ReplaceState.viewState == PlayerState.ready) {
            combatBloc.add(SetupAttackerEvent());
          }
        }
        break;
      default:
        break;

      //   // Validate Wining Condition
      //   if (game.player1ValidateLoss || game.player2ValidateLoss) {
      //     return;
      //   }
    }
  }
}
