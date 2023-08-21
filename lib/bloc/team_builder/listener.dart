import 'package:flame_bloc/flame_bloc.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/bloc/team_builder/bloc.dart';
import 'package:skygame_2d/bloc/team_builder/state.dart';
import 'package:skygame_2d/scenes/team_builder.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/utils.dart/extensions.dart';

extension KeyInputBlocListenerExt on TeamBuilderScene {
  FlameBlocListener teamBuilderBlocListener() {
    return FlameBlocListener<TeamBuilderBloc, TeamBuilderBlocState>(
      onNewState: (state) async {
        switch (state.viewState) {
          case TeamBuilderViewState.team: // Focus on team list
            teamsCollComp.isVisible = true;
            activeTeamComp.isVisible = false;
            collectionComp.isVisible = false;
            _refreshSelectedItem();
            break;
          case TeamBuilderViewState.builder: // Focus on single unit team list
            teamsCollComp.isVisible = true;
            activeTeamComp.isVisible = true;
            collectionComp.isVisible = true;
            activeTeamComp.team.value = state.selectedUnits;
            collectionComp.units.value = state.collection;
            _refreshSelectedActiveTeamItem();
            break;
          case TeamBuilderViewState.characterSelect: // Focus on collection
            teamsCollComp.isVisible = false;
            activeTeamComp.isVisible = true;
            collectionComp.isVisible = true;
            _refreshSelectedCharacterItem();
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
    for (var item in teamsCollComp.menuItemList) {
      item.isSelected = false;
    }
    final item = teamsCollComp.menuItemList
        .firstWhereOrNull((e) => e.index == game.keyBloc.state.currentIndex);
    item?.isSelected = true;
  }

  void _refreshSelectedActiveTeamItem() {
    for (var item in activeTeamComp.selectableChildren) {
      item.isSelected = false;
    }

    final item = activeTeamComp.selectableChildren
        .firstWhereOrNull((e) => e.index == game.keyBloc.state.currentIndex);
    item?.isSelected = true;
  }

  void _refreshSelectedCharacterItem() {
    for (var item in collectionComp.selectableChildren) {
      item.isSelected = false;
    }

    final item = collectionComp.selectableChildren
        .firstWhereOrNull((e) => e.index == game.keyBloc.state.currentIndex);
    item?.isSelected = true;
  }
}
