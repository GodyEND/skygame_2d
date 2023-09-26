import 'package:bloc/bloc.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/bloc/player/events.dart';
import 'package:skygame_2d/bloc/player/state.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/scenes/team_formation/bloc/event.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/models/match_unit/unit_render_ext.dart';

class PlayerBloc extends Bloc<BlocEvent, PlayerBlocState> {
  PlayerBloc(super.initialState) {
    on<UpdatePlayerEvent>(
        (event, emit) => emit(state.copyWith(cPlayer: event.player)));
    on<DefeatLeadEvent>((event, emit) {
      emit(state.copyWith(cPoints: state.points + 2));
    });
    on<DefeatAceEvent>((event, emit) {
      emit(state.copyWith(cPoints: state.points + 1));
    });
    on<UpdatePlayerFormationEvent>(((event, emit) {
      final updatedRoster = {
        MatchPosition.lead: generateMatchUnit(
          unit: event.formation[0],
          matchPosition: MatchPosition.lead,
          ownerID: state.player.ownerID,
        ),
        MatchPosition.leftAce: generateMatchUnit(
          unit: event.formation[1],
          matchPosition: MatchPosition.leftAce,
          ownerID: state.player.ownerID,
        ),
        MatchPosition.rightAce: generateMatchUnit(
          unit: event.formation[2],
          matchPosition: MatchPosition.rightAce,
          ownerID: state.player.ownerID,
        ),
        MatchPosition.leftLink: generateMatchUnit(
          unit: event.formation[3],
          matchPosition: MatchPosition.leftLink,
          ownerID: state.player.ownerID,
        ),
        MatchPosition.rightLink: generateMatchUnit(
          unit: event.formation[4],
          matchPosition: MatchPosition.rightLink,
          ownerID: state.player.ownerID,
        ),
        MatchPosition.reserve1: generateReserveUnit(
          unit: event.reserve[0],
          matchPosition: MatchPosition.reserve1,
          ownerID: state.player.ownerID,
        ),
        MatchPosition.reserve2: generateReserveUnit(
          unit: event.reserve[1],
          matchPosition: MatchPosition.reserve2,
          ownerID: state.player.ownerID,
        ),
        MatchPosition.reserve3: generateReserveUnit(
          unit: event.reserve[2],
          matchPosition: MatchPosition.reserve3,
          ownerID: state.player.ownerID,
        ),
        MatchPosition.reserve4: generateReserveUnit(
          unit: event.reserve[3],
          matchPosition: MatchPosition.reserve4,
          ownerID: state.player.ownerID,
        ),
        MatchPosition.reserve5: generateReserveUnit(
          unit: event.reserve[4],
          matchPosition: MatchPosition.reserve5,
          ownerID: state.player.ownerID,
        ),
      };

      final updatedMatchFormation = List<MatchUnit>.from([
        updatedRoster[MatchPosition.lead],
        updatedRoster[MatchPosition.leftAce],
        updatedRoster[MatchPosition.rightAce],
        updatedRoster[MatchPosition.leftLink],
        updatedRoster[MatchPosition.rightLink],
      ].where((e) => e != null).toList());

      final updatedMatchReserve = List<MatchUnit>.from([
        updatedRoster[MatchPosition.reserve1],
        updatedRoster[MatchPosition.reserve2],
        updatedRoster[MatchPosition.reserve3],
        updatedRoster[MatchPosition.reserve4],
        updatedRoster[MatchPosition.reserve5],
      ].where((e) => e != null).toList());
      emit(state.copyWith(
        cRoster: updatedRoster,
        cPlayer: state.player.copyWith(
          cMatchFormation: updatedMatchFormation,
          cMatchReserve: updatedMatchReserve,
        ),
      ));
    }));
    on<ConfirmReplacementEvent>((event, emit) {});
  }

  MatchUnit? generateMatchUnit({
    required Unit? unit,
    required MatchPosition matchPosition,
    required int ownerID,
  }) {
    if (unit == null) return null;
    final newUnit = MatchUnit(
      unit,
      id: matchPosition.index + (ownerID - 1) * MatchPosition.values.length,
      ownerID: ownerID,
      position: matchPosition,
      target: MatchHelper.getDefaultTarget(matchPosition),
      links: const [],
    );
    newUnit.addMatchAssets();
    return newUnit;
  }

  MatchUnit? generateReserveUnit({
    required Unit? unit,
    required MatchPosition matchPosition,
    required int ownerID,
  }) {
    if (unit == null) return null;
    final newUnit = MatchUnit(
      unit,
      id: matchPosition.index + (ownerID - 1) * MatchPosition.values.length,
      ownerID: ownerID,
      position: matchPosition,
      target: MatchHelper.getDefaultTarget(matchPosition),
      links: const [],
    );
    newUnit.addMatchAssets();
    return newUnit;
  }
}
