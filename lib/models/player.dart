import 'package:equatable/equatable.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/models/match_unit/unit_team.dart';

class Player extends Equatable {
  final int ownerID;
  final List<UnitTeam> teams;
  final List<Unit> collection;
  final UnitTeam? activeTeam;
  final List<Unit> formation;

  const Player(
    this.ownerID, {
    required this.teams,
    required this.collection,
    this.activeTeam,
    required this.formation,
  });

  Player copyWith({
    UnitTeam? cActiveTeam,
    List<Unit>? cFormation,
  }) {
    return Player(
      ownerID,
      teams: teams,
      collection: collection,
      activeTeam: cActiveTeam ?? activeTeam,
      formation: cFormation ?? formation,
    );
  }

  @override
  List<Object?> get props => [
        ownerID,
        teams,
        collection,
        activeTeam,
        formation,
      ];
}
