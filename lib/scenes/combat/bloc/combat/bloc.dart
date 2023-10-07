import 'package:bloc/bloc.dart';
import 'package:skygame_2d/scenes/combat/bloc/combat/events.dart';
import 'package:skygame_2d/scenes/combat/bloc/combat/state.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/simulation.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/graphics/animations.dart';
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
        state.defender!.asset.animationListener.value = renderCombatAnimation(
            event.dt, state.combatEvent, state.defender!, false);

        // Prepare Combat Assets
        AnimationsManager.prepareCombat(state.attacker!, state.defender!);
        emit(state.copyWith());
      },
    );

    on<CombatAnimationEndEvent>((event, emit) {
      if (state.attacker?.current.stats.values[StatType.hp] == 0 &&
          state.attacker?.position != MatchPosition.replaceable) {
        state.field[state.attacker!.ownerID]![state.attacker!.position] = null;
        emit(state.copyWith(cField: Map.from(state.field)));
        add(UpdateScoreEvent(
            state.defender!.ownerID, state.attacker!.position));
        state.attacker?.position = MatchPosition.replaceable;
      } else if (state.defender?.current.stats.values[StatType.hp] == 0 &&
          state.defender?.position != MatchPosition.replaceable) {
        state.field[state.defender!.ownerID]![state.defender!.position] = null;
        emit(state.copyWith(cField: Map.from(state.field)));
        add(UpdateScoreEvent(
            state.attacker!.ownerID, state.defender!.position));
        state.defender?.position = MatchPosition.replaceable;
      } else {
        add(UpdateExeQEvent(units: state.allUnits, oldQ: state.exeQ));
      }
    });

    on<UpdateScoreEvent>(
      (event, emit) {
        final oldPlayerState = state.playerStates[event.winningPlayerID - 1];
        final newPlayerState = oldPlayerState.copyWith(
            cPoints: event.defeatedPos == MatchPosition.lead
                ? 2
                : 1 + oldPlayerState.points);
        state.playerStates[event.winningPlayerID - 1] = newPlayerState;
        // Update Score
        emit(state.copyWith(
          cPlayerStates: List.from(state.playerStates),
          cEvent: event,
          cCombatState: CombatState.replace,
        ));
      },
    );

    // on<ReplaceUnitEvent>(
    //   (event, emit) {
    //     // Replace defeated Units
    //     final opponentID = MatchHelper.getOpponent(event.ownerID);
    //     // Get Random from backrow
    //     final fieldRepList = List<MatchUnit>.from([
    //       state.field[opponentID - 1]?[MatchPosition.leftLink],
    //       state.field[opponentID - 1]?[MatchPosition.rightLink],
    //     ].where((e) => e != null).toList());
    //     if (fieldRepList.isNotEmpty) {
    //       var rand = Random().nextInt(fieldRepList.length);
    //       final fieldRep = fieldRepList[rand];
    //       final reservePos = fieldRep.position;
    //       fieldRep.position = event.defeatedPos;
    //       state.field[opponentID - 1]![event.defeatedPos] = fieldRep;

    //       // Get Random from reserve
    //       final reserveRepList = List<MatchUnit>.from(
    //           state.playerStates[opponentID - 1].player.matchReserve);
    //       if (reserveRepList.isNotEmpty) {
    //         var rand2 = Random().nextInt(reserveRepList.length);
    //         final reserveRep = reserveRepList[rand2];
    //         reserveRep.position = reservePos;
    //         state.field[opponentID - 1]![reservePos] = reserveRep;
    //         state.playerStates[opponentID - 1].player.matchReserve
    //             .remove(reserveRep);
    //       } else {
    //         state.field[opponentID - 1]![reservePos] = null;
    //       }
    //     } else {
    //       state.field[opponentID - 1]?[event.defeatedPos] = null;
    //     }

    //     bool combatIsValid = true;
    //     for (var pField in state.field.values.toList()) {
    //       for (var pos in pField.keys.toList()) {
    //         if (MatchHelper.isField(pos)) {
    //           if (pField[pos]?.position == MatchPosition.replaceable ||
    //               (pField[pos] == null && MatchHelper.hasReserve(pField))) {
    //             combatIsValid = false;
    //           }
    //         }
    //         if (!combatIsValid) break;
    //       }
    //       if (!combatIsValid) break;
    //     }

    //     emit(state.copyWith(cField: Map.from(state.field)));

    //     if (combatIsValid) {
    //       add(UpdateExeQEvent(units: state.allUnits, oldQ: state.exeQ));
    //     }
    //   },
    // );

    on<UpdateExeQEvent>((event, emit) {
      int turn = state.turn;
      if (event.oldQ.length == 1) {
        turn += 1;
      }
      emit(state.copyWith(
        cExeQ: event.exeQ,
        cTurn: turn,
        cEvent: event,
        clearAttacker: true,
        clearDefender: true,
      ));
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
