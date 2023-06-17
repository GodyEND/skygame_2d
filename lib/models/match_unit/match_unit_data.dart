// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:skygame_2d/models/bes.dart';
import 'package:skygame_2d/models/costs.dart';
import 'package:skygame_2d/models/enums.dart';
import 'package:skygame_2d/models/fx.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/models/release.dart';
import 'package:skygame_2d/models/stats.dart';

class MatchUnitData extends Equatable {
  Stats stats;
  Release release;
  FX fx;
  BES bes;
  Costs costs;
  Species species;

  MatchUnitData({required Unit character})
      : stats = Stats(
          hp: character.stats[StatType.hp] * 5,
          storage: character.stats[StatType.storage] * 4,
          atk: character.stats[StatType.attack],
          def: character.stats[StatType.defense],
          charge: character.stats[StatType.charge],
          exe: character.stats[StatType.execution],
        ),
        release = character.release,
        bes = character.bes,
        costs = character.costs,
        fx = character.fx,
        species = character.species;

  @override
  List<Object?> get props => [
        release,
        stats,
        bes,
        costs,
        fx,
        species,
      ];
}
