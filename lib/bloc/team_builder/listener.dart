import 'package:bloc/bloc.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:skygame_2d/bloc/key_input/bloc.dart';
import 'package:skygame_2d/bloc/key_input/state.dart';
import 'package:skygame_2d/bloc/team_builder/bloc.dart';
import 'package:skygame_2d/bloc/team_builder/state.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/scenes/team_builder.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

extension KeyInputBlocListenerExt on TeamBuilderScene {
  FlameBlocListener teamBuilderBlocListener() {
    return FlameBlocListener<TeamBuilderBloc, TeamBuilderBlocState>(
      onNewState: (state) {
        switch (state.viewState) {
          case TeamBuilderViewState.team: // Focus on team list
            break;
          case TeamBuilderViewState.builder: // Focus on single unit team list
            break;
          case TeamBuilderViewState.characterSelect: // Focus on collection
            break;
          case TeamBuilderViewState.teamName: // Focus on name text field
            break;
          case TeamBuilderViewState.wait: // disable buttons except cancel
            break;
          default:
            break;
        }
      },
      bloc: teamBuilderBloc,
    );
  }
}
