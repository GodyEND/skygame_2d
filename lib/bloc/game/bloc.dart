import 'package:bloc/bloc.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/bloc/game/state.dart';
import 'package:skygame_2d/models/enums.dart';

class GameBloc extends Bloc<BlocEvent, GameBlocState> {
  GameBloc(super.initialState) {
    on<PlayerTeamReadyEvent>((event, emit) {
      bool playersReady = true;
      for (var playerState in state.playerStates) {
        if (playerState.state != PlayerState.ready) {
          playersReady = false;
          break;
        }
      }
      if (playersReady) {
        emit(state.copyWith(cGameState: GameState.combat));
      }
    });
    on<CombatTurnEnd>((event, emit) => emit(
        state.copyWith(cGameState: state.gameState, cTurn: state.turn + 1)));
  }
}

//  event.player. .setUnit(this, BrawlType.lead, Unit.fromRAND());
      // player1.setUnit(this, BrawlType.leftAce, Unit.fromRAND());
      // player1.setUnit(this, BrawlType.rightAce, Unit.fromRAND());
      // player1.setUnit(this, BrawlType.leftLink, Unit.fromRAND());
      // player1.setUnit(this, BrawlType.rightLink, Unit.fromRAND());
      // player1.setUnit(this, BrawlType.reserve1, Unit.fromRAND());
      // player1.setUnit(this, BrawlType.reserve2, Unit.fromRAND());
      // player1.setUnit(this, BrawlType.reserve3, Unit.fromRAND());