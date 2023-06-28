import 'package:flame_bloc/flame_bloc.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/bloc/player/bloc.dart';
import 'package:skygame_2d/bloc/player/state.dart';
import 'package:skygame_2d/main.dart';

extension PlayerBlocListenerExt on SkyGame2D {
  FlameBlocListener playerBlocListener(PlayerBloc playerBloc) {
    return FlameBlocListener<PlayerBloc, PlayerBlocState>(
      onNewState: (state) {
        if (state.event is PlayerTeamReadyEvent) {
          bloc.add(PlayerTeamReadyEvent());
        }
      },
      bloc: playerBloc,
    );
  }
}
