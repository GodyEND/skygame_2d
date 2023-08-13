import 'package:flame_bloc/flame_bloc.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/bloc/team_builder/bloc.dart';
import 'package:skygame_2d/bloc/team_builder/state.dart';
import 'package:skygame_2d/graphics/teams_collection.dart';
import 'package:skygame_2d/scenes/team_builder.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/utils.dart/extensions.dart';

extension KeyInputBlocListenerExt on TeamBuilderScene {
  FlameBlocListener teamBuilderBlocListener() {
    return FlameBlocListener<TeamBuilderBloc, TeamBuilderBlocState>(
      onNewState: (state) async {
        switch (state.viewState) {
          case TeamBuilderViewState.team: // Focus on team list
            _refreshSelectedItem();
            teamsCollComp.isVisible = true;
            activeTeamComp.isVisible = false;
            collectionComp.isVisible = false;
            break;
          case TeamBuilderViewState.builder: // Focus on single unit team list
            teamsCollComp.isVisible = true;
            activeTeamComp.isVisible = true;
            collectionComp.isVisible = true;
            activeTeamComp.team = state.selectedUnits;
            collectionComp.units = state.collection;
            await activeTeamComp.refresh();
            await collectionComp.refresh();
            break;
          case TeamBuilderViewState.characterSelect: // Focus on collection
            teamsCollComp.isVisible = false;
            activeTeamComp.isVisible = true;
            collectionComp.isVisible = true;
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
    final teamsColl = sceneComponents.whereType<TeamsCollectionComponent>();
    for (var teams in teamsColl) {
      for (var item in teams.menuItemList) {
        item.isSelected = false;
      }

      final item = teams.menuItemList
          .firstWhereOrNull((e) => e.index == game.keyBloc.state.colIndex);
      // final item = menuItems.firstWhereOrNull((e) =>
      //     e.index ==
      //     game.keyBloc.state.colIndex * game.keyBloc.state.rowLength +
      //         game.keyBloc.state.rowIndex);
      item?.isSelected = true;
    }
  }
}
