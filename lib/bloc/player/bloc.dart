import 'package:bloc/bloc.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/bloc/player/events.dart';
import 'package:skygame_2d/bloc/player/state.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/models/match_unit/unit_render_ext.dart';

class PlayerBloc extends Bloc<BlocEvent, PlayerBlocState> {
  PlayerBloc(super.initialState) {
    on<DefeatLeadEvent>((event, emit) {
      emit(state.copyWith(cPoints: state.points + 2));
    });
    on<DefeatAceEvent>((event, emit) {
      emit(state.copyWith(cPoints: state.points + 1));
    });
    on<SetPlayerUnitEvent>((event, emit) {
      final newUnit = MatchUnit(
        event.unit,
        id: event.position.index +
            (event.ownerID - 1) * MatchPosition.values.length,
        ownerID: event.ownerID,
        position: event.position,
        target: MatchHelper.getDefaultTarget(event.position),
        links: const [],
      );
      newUnit.addMatchAssets();
      state.roster[event.position] = newUnit;
      // state.units.add(newUnit);

      emit(PlayerReadyBlocState(
        ownerID: state.ownerID,
        roster: state.roster,
      ));
    });
    on<ConfirmReplacementEvent>((event, emit) {});
  }
}
