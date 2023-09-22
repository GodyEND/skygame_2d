import 'package:equatable/equatable.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/models/match_unit/unit_team.dart';

class Player extends Equatable {
  final int ownerID;
  final List<UnitTeam> teams;
  final List<Unit> collection;
  final UnitTeam? activeTeam;
  final List<Unit> formation;
  final List<MatchUnit?> matchFormation;
  final List<MatchUnit?> matchReserve;

  const Player(
    this.ownerID, {
    required this.teams,
    required this.collection,
    this.activeTeam,
    required this.formation,
    required this.matchFormation,
    required this.matchReserve,
  });

  Player copyWith({
    UnitTeam? cActiveTeam,
    List<Unit>? cFormation,
    List<MatchUnit>? cMatchFormation,
    List<MatchUnit>? cMatchReserve,
  }) {
    return Player(
      ownerID,
      teams: teams,
      collection: collection,
      activeTeam: cActiveTeam ?? activeTeam,
      formation: cFormation ?? formation,
      matchFormation: cMatchFormation ?? matchFormation,
      matchReserve: cMatchReserve ?? matchReserve,
    );
  }

  @override
  List<Object?> get props => [
        ownerID,
        teams,
        collection,
        activeTeam,
        formation,
        matchFormation,
        matchReserve,
      ];
}
