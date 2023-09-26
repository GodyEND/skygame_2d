import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/graphics/teams_collection.dart';
import 'package:skygame_2d/graphics/unit_collection.dart';
import 'package:skygame_2d/graphics/unit_team_active_component.dart';
import 'package:skygame_2d/scenes/team_builder/bloc/bloc.dart';
import 'package:skygame_2d/scenes/team_builder/bloc/state.dart';
import 'package:skygame_2d/scenes/team_builder/team_builder.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/utils.dart/extensions.dart';

extension TeamBuilderBlocListenerExt on TeamBuilderScene {
  FlameBlocListener teamBuilderBlocListener() {
    return FlameBlocListener<TeamBuilderBloc, TeamBuilderBlocState>(
      onNewState: (state) async {
        final teamComp = game.findByKey<TeamsCollectionComponent>(
            ComponentKey.named(TBComponentKeys.teams.asKey(ownerID)));
        final activeComp = game.findByKey<ActiveUnitTeamComponent>(
            ComponentKey.named(TBComponentKeys.active.asKey(ownerID)));
        final collectionComp = game.findByKey<UnitCollectionComponent>(
            ComponentKey.named(TBComponentKeys.collection.asKey(ownerID)));
        final waitComp = game.findByKey<VisibleWrapperComponent>(
            ComponentKey.named(TBComponentKeys.waiting.asKey(ownerID)));
        switch (state.viewState) {
          case TeamBuilderViewState.team: // Focus on team list
            teamComp?.isVisible = true;
            activeComp?.isVisible = false;
            collectionComp?.isVisible = false;
            waitComp?.isVisible = false;
            teamComp?.teams.value = state.teams;
            _refreshSelectedItem(teamComp);
            break;
          case TeamBuilderViewState.builder: // Focus on single unit team list
            teamComp?.isVisible = true;
            activeComp?.isVisible = true;
            collectionComp?.isVisible = true;
            waitComp?.isVisible = false;
            activeComp?.team.value = state.selectedUnits;
            collectionComp?.units.value = state.collection;

            _refreshSelectedActiveTeamItem(activeComp);
            break;
          case TeamBuilderViewState.characterSelect: // Focus on collection
            teamComp?.isVisible = false;
            activeComp?.isVisible = true;
            collectionComp?.isVisible = true;
            waitComp?.isVisible = false;
            _refreshSelectedCharacterItem(collectionComp);
            break;
          case TeamBuilderViewState.teamName: // Focus on name text field
            break;
          case TeamBuilderViewState.wait: // disable buttons except cancel
            waitComp?.isVisible = true;
            _refreshSelectedItem(teamComp);
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

  void _refreshSelectedItem(TeamsCollectionComponent? teamsCollComp) {
    for (var item in teamsCollComp?.menuItemList ?? []) {
      item.isHovered = false;
      item.isSelected = false;
    }
    final item = teamsCollComp?.menuItemList
        .firstWhereOrNull((e) => e.index == keyBloc.state.currentIndex);
    item?.isHovered = true;

    final selected = teamsCollComp?.menuItemList.firstWhereOrNull(
        (e) => e.team.id == teamBuilderBloc.state.player.activeTeam?.id);
    selected?.isSelected = true;
  }

  void _refreshSelectedActiveTeamItem(ActiveUnitTeamComponent? activeTeamComp) {
    for (var item in activeTeamComp?.selectableChildren ?? []) {
      item.isHovered = false;
    }

    final item = activeTeamComp?.selectableChildren
        .firstWhereOrNull((e) => e.index == keyBloc.state.currentIndex);
    item?.isHovered = true;
  }

  void _refreshSelectedCharacterItem(UnitCollectionComponent? collectionComp) {
    for (var item in collectionComp?.selectableChildren ?? []) {
      item.isHovered = false;
    }

    final item = collectionComp?.selectableChildren
        .firstWhereOrNull((e) => e.index == keyBloc.state.currentIndex);
    item?.isHovered = true;
  }
}
