import 'package:equatable/equatable.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

class ReplaceBlocState extends Equatable {
  final int ownerID;
  final List<MatchUnit> replacements;
  final List<MatchUnit> replaceable;
  final List<MatchUnit> defeated;
  final PlayerState viewState;
  final BlocEvent? event;
  final Map<MatchPosition, MatchUnit?> field;

  const ReplaceBlocState({
    required this.ownerID,
    required this.replacements,
    required this.replaceable,
    required this.defeated,
    required this.viewState,
    this.event,
    required this.field,
  });

  ReplaceBlocState copyWith(
      {List<MatchUnit>? cReplacements,
      List<MatchUnit>? cReplaceable,
      List<MatchUnit>? cDefeated,
      PlayerState? cViewState,
      Map<MatchPosition, MatchUnit>? cField,
      BlocEvent? cEvent}) {
    return ReplaceBlocState(
      ownerID: ownerID,
      replacements: cReplacements ?? replacements,
      replaceable: cReplaceable ?? replaceable,
      defeated: cDefeated ?? defeated,
      viewState: cViewState ?? viewState,
      field: cField ?? field,
      event: cEvent,
    );
  }

  @override
  List<Object?> get props => [
        ownerID,
        replacements,
        replaceable,
        defeated,
        viewState,
        field,
        event,
      ];

  Map<MatchPosition, MatchUnit?> get getFieldFromState {
    return {
      ...field,
      ...getReplacementEntries,
    };
  }

  Map<MatchPosition, MatchUnit?> get getReplacementEntries {
    Map<MatchPosition, MatchUnit?> result = {};
    for (int i = 0; i < replacements.length; i++) {
      result[MatchPosition.values[5 + i]] = replacements[i];
    }
    return result;
  }
}

class InitiateReplacementBlocState extends ReplaceBlocState {
  InitiateReplacementBlocState(int ownerID,
      Map<MatchPosition, MatchUnit?> field, List<MatchUnit> defeated)
      : super(
          ownerID: ownerID,
          field: getConfirmedField(field),
          replacements: getConfirmedReplacements(field),
          replaceable: getConfirmedReplaceable(field),
          defeated: getDefeated(field, defeated),
          viewState: PlayerState.replace,
        );
}

class ValidateReadyReplaceBlocState extends ReplaceBlocState {
  ValidateReadyReplaceBlocState(ReplaceBlocState state)
      : super(
          ownerID: state.ownerID,
          field: state.field,
          replacements: state.replacements,
          replaceable: state.replaceable,
          defeated: state.defeated,
          viewState: (state.replaceable.isEmpty)
              ? PlayerState.ready
              : PlayerState.replace,
        );
}

Map<MatchPosition, MatchUnit?> getConfirmedField(
    Map<MatchPosition, MatchUnit?> oldField) {
  final newField = Map<MatchPosition, MatchUnit?>.from(oldField);
  for (var key in oldField.keys.toList()) {
    if (!MatchHelper.isField(oldField[key]?.position ?? MatchPosition.none)) {
      newField.remove(key);
    }
  }
  return newField;
}

List<MatchUnit> getConfirmedReplacements(
    Map<MatchPosition, MatchUnit?> oldField) {
  final newField = Map<MatchPosition, MatchUnit?>.from(oldField);
  newField.removeWhere(
      (key, value) => value == null || MatchHelper.isField(value.position));
  return List<MatchUnit>.from(newField.values.toList());
}

List<MatchUnit> getConfirmedReplaceable(
    Map<MatchPosition, MatchUnit?> oldField) {
  final newField = Map<MatchPosition, MatchUnit?>.from(oldField);
  newField.removeWhere(
      (key, value) => value?.position != MatchPosition.replaceable);
  return List<MatchUnit>.from(newField.values.toList());
}

List<MatchUnit> getDefeated(
    Map<MatchPosition, MatchUnit?> oldField, List<MatchUnit> oldDefeated) {
  final newField = Map<MatchPosition, MatchUnit?>.from(oldField);
  newField
      .removeWhere((key, value) => value?.position != MatchPosition.defeated);
  return List<MatchUnit>.from([...oldDefeated, ...newField.values.toList()]);
}

// class UpdateFieldEvent extends BlocEvent {
//   final CombatBloc combatBloc;
//   UpdateFieldEvent(this.combatBloc) {
//     combatBloc.add(event)
//   }
// }
