import 'package:bloc/bloc.dart';
import 'package:flame/components.dart';
import 'package:skygame_2d/bloc/combat/events.dart';
import 'package:skygame_2d/bloc/combat/state.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/simulation.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/graphics/animations.dart';
import 'package:skygame_2d/scenes/combat.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

class CombatBloc extends Bloc<BlocEvent, CombatBlocState> {
  CombatBloc({required CombatBlocState initialState}) : super(initialState) {
    on<StartCombatEvent>(((event, emit) {
      emit(state.copyWith(cExeQ: _orderList, cEvent: event));
      for (var unit in state.allUnits) {
        unit.render(0.3);
      }
      add(SetupAttackerEvent());
    }));

    on<SetupAttackerEvent>((event, emit) {
      final newCombatState =
          activeUnit.eventQ.isEmpty ? CombatState.attack : CombatState.none;

      final attacker = activeUnit;
      final defender = MatchHelper.getTarget(activeUnit, state.field);
      emit(state.copyWith(
        cAttacker: attacker,
        cDefender: defender,
        cCombatState: newCombatState,
        cEvent: event,
      ));

      if (newCombatState == CombatState.attack) {
        add(SimulateCombatEvent(
          attacker: attacker,
          defender: defender,
        ));
      }
    });

    on<SimulateCombatEvent>((event, emit) {
      final combatEvent =
          Simulator.combatEventResult(state, event.attacker, event.defender);
      Simulator.calculateDamage(combatEvent, event.attacker, event.defender);
      Simulator.setCharge(combatEvent, event.attacker, event.defender);
      Simulator.applyDamage(event.attacker, event.defender);

      emit(state.copyWith(
        cAttacker: event.attacker,
        cDefender: event.defender,
        cCombatEvent: combatEvent,
        cEvent: event,
      ));
    });

    on<FireCombatAnimationEvent>(
      (event, emit) {
        state.attacker!.asset.animationListener.value = renderCombatAnimation(
            event.dt, state.combatEvent, state.attacker!, true);
        state.attacker!.render(event.dt);
        state.defender!.asset.animationListener.value = renderCombatAnimation(
            event.dt, state.combatEvent, state.defender!, false);
        state.defender!.render(event.dt);

        // Prepare Combat Assets
        AnimationsManager.prepareCombat(state.attacker!, state.defender!);
        AnimationsManager.animateEventText(
          event.dt,
          state.combatEvent,
          event.game.findByKeyName<TextComponent>(
              CombatComponentKey.combatEvent.asKey())!,
        );
        emit(state.copyWith());
      },
    );

    on<UpdateExeQEvent>((event, emit) {
      emit(state.copyWith(cExeQ: event.exeQ));
    });
  }

  MatchUnit get activeUnit => state.exeQ.first;

  List<MatchUnit> get _orderList {
    state.exeQ.sort((a, b) => b.current.stats[StatType.execution]
        .compareTo(a.current.stats[StatType.execution]));
    return List<MatchUnit>.from(state.exeQ);
  }

  Function() renderCombatAnimation(double dt, CombatEventResult event,
          MatchUnit unit, bool isAttacker) =>
      () => AnimationsManager.animateCombat(dt, event, unit,
          isAttacker: isAttacker);
}
