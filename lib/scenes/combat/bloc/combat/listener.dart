import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:skygame_2d/scenes/combat/bloc/combat/bloc.dart';
import 'package:skygame_2d/scenes/combat/bloc/combat/events.dart';
import 'package:skygame_2d/scenes/combat/bloc/combat/state.dart';
import 'package:skygame_2d/game/combat_ui/brawl_q.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/scenes/combat/combat.dart';
import 'package:skygame_2d/scenes/replace/replace.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

FlameBlocListener combatBlocListener(CombatScene scene, CombatBloc combatBloc) {
  return FlameBlocListener<CombatBloc, CombatBlocState>(
    onNewState: (state) {
      final replaceScene = scene.game
          .findByKeyName<ReplaceScene>(CombatComponentKey.replace.asKey())!;
      replaceScene.isVisible = false;

      switch (state.combatState) {
        case CombatState.replace:
          replaceScene.isVisible = true;
          break;
        case CombatState.attack:
          if (state.event is UpdateExeQEvent) {
            final queueComp = scene.game.findByKeyName<BrawlQComponent>(
                CombatComponentKey.queue.asKey());
            queueComp?.units = combatBloc.state.allUnits
                .where((e) => MatchHelper.isFrontrow(e.position))
                .toList();
            queueComp?.animatedQ.value = List.from(combatBloc.state.exeQ);
            combatBloc.add(SetupAttackerEvent());
          } else if (state.event is UpdateScoreEvent) {
            final scoreComp = scene.game
                .findByKeyName<TextComponent>(CombatComponentKey.score.asKey());
            scoreComp?.text =
                '${state.playerStates[0].points} : ${state.playerStates[1].points}';
          }
          break;
        default:
          break;
      }
    },
    bloc: combatBloc,
  );
}
