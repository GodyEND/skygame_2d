import 'package:flame_bloc/flame_bloc.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/graphics/unit_team_active_component.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/models/match_unit/unit_team.dart';
import 'package:skygame_2d/scenes/team_builder/team_builder.dart';
import 'package:skygame_2d/scenes/team_formation/bloc/bloc.dart';
import 'package:skygame_2d/scenes/team_formation/bloc/event.dart';
import 'package:skygame_2d/scenes/team_formation/bloc/state.dart';
import 'package:skygame_2d/scenes/team_formation/team_formation_scene.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/utils.dart/extensions.dart';

extension TeamFormationBlocListenerExt on TeamFormationScene {
  FlameBlocListener teamFormationBlocListener() {
    return FlameBlocListener<TeamFormationBloc, TeamFormationBlocState>(
      onNewState: (state) async {
        final teamComp = game.findByKeyName<ActiveUnitTeamComponent>(
            TFComponentKeys.team.asKey(ownerID));
        final waitComp = game.findByKeyName<VisibleWrapperComponent>(
            TFComponentKeys.waiting.asKey(ownerID));
        switch (state.viewState) {
          case TeamFormationViewState.formation: // Focus on team list
            teamComp?.isVisible = false;
            for (var comp in formationComponents) {
              comp.isVisible = true;
            }
            waitComp?.isVisible = false;
            _refreshSelectedItem(event: state.event);
            if (_isReady()) {
              teamFormationBloc.playerReady();
            }
            break;
          case TeamFormationViewState
                .characterSelect: // Focus on single unit team list
            teamComp?.isVisible = true;
            for (var comp in formationComponents) {
              comp.isVisible = true;
            }
            waitComp?.isVisible = false;
            _refreshSelectedCharacterItem();
            break;
          case TeamFormationViewState.wait: // disable buttons except cancel
            teamComp?.isVisible = true;
            for (var comp in formationComponents) {
              comp.isVisible = true;
            }
            waitComp?.isVisible = true;
            _refreshSelectedItem();
            break;
          default:
            break;
        }
        if (state.event is EmptyEvent) {
          teamFormationBloc.clear();
        }
      },
      bloc: teamFormationBloc,
    );
  }

  void _refreshSelectedItem({BlocEvent? event}) {
    for (int i = 0; i < formationComponents.length; i++) {
      formationComponents[i].unit.value = teamFormationBloc.state.formation[i];
    }
    for (var comp in formationComponents) {
      comp.selectedIndex.value = keyBloc.state.currentIndex;
    }
    if (event is ConfirmTFEvent) {
      if (event.ownerID != ownerID) return;
      playerBloc.add(UpdatePlayerFormationEvent(
        List<Unit?>.from(teamFormationBloc.state.formation),
        List<Unit>.from(
          teamFormationBloc.state.characterOptions,
        ),
      ));
      game
          .findByKeyName<ActiveUnitTeamComponent>(
              TFComponentKeys.team.asKey(ownerID))
          ?.team
          .value = UnitTeam(-1, list: teamFormationBloc.state.characterOptions);
    }
  }

  void _refreshSelectedCharacterItem() {
    final teamComp = game.findByKeyName<ActiveUnitTeamComponent>(
        TFComponentKeys.team.asKey(ownerID));
    teamComp?.isVisible = true;
    for (var item in teamComp?.selectableChildren ?? []) {
      item.isHovered = false;
    }

    final item = teamComp?.selectableChildren
        .firstWhereOrNull((e) => e.index == keyBloc.state.currentIndex);
    item?.isHovered = true;
  }

  bool _isReady() {
    return teamFormationBloc.state.formation
            .where((e) => e != null)
            .toList()
            .length >=
        5;
  }
}
