import 'package:equatable/equatable.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/models/match_unit/unit_team.dart';

class Player extends Equatable {
  final int ownerID;
  final List<UnitTeam> teams;
  final List<Unit> collection;

  const Player(
    this.ownerID, {
    required this.teams,
    required this.collection,
  });

  @override
  List<Object?> get props => [
        ownerID,
        teams,
        collection,
      ];
}
