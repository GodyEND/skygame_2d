import 'package:flame_bloc/flame_bloc.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/bloc/team_builder/bloc.dart';
import 'package:skygame_2d/bloc/team_builder/state.dart';
import 'package:skygame_2d/graphics/unit_team_component.dart';
import 'package:skygame_2d/scenes/team_builder.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/utils.dart/extensions.dart';

extension KeyInputBlocListenerExt on TeamBuilderScene {
  FlameBlocListener teamBuilderBlocListener() {
    return FlameBlocListener<TeamBuilderBloc, TeamBuilderBlocState>(
      onNewState: (state) {
        switch (state.viewState) {
          case TeamBuilderViewState.team: // Focus on team list
            _refreshSelectedItem();
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
        if (state.event is EmptyEvent) {
          teamBuilderBloc.clear();
        }
      },
      bloc: teamBuilderBloc,
    );
  }

  void _refreshSelectedItem() {
    final menuItems = List<UnitTeamComponent>.from(
        sceneComponents.whereType<UnitTeamComponent>());
    for (var item in menuItems) {
      item.isSelected = false;
    }

    final item = menuItems
        .firstWhereOrNull((e) => e.index == game.keyBloc.state.colIndex);
    // final item = menuItems.firstWhereOrNull((e) =>
    //     e.index ==
    //     game.keyBloc.state.colIndex * game.keyBloc.state.rowLength +
    //         game.keyBloc.state.rowIndex);
    item?.isSelected = true;
  }
}
