import 'package:equatable/equatable.dart';
import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/trackers.dart';
import 'package:skygame_2d/graphics/unit_animations.dart';
import 'package:skygame_2d/models/bes.dart';
import 'package:skygame_2d/models/costs.dart';
import 'package:skygame_2d/models/enums.dart';
import 'package:skygame_2d/models/fx.dart';
import 'package:skygame_2d/models/player.dart';
import 'package:skygame_2d/models/release.dart';
import 'package:skygame_2d/models/stats.dart';
import 'package:skygame_2d/models/unit.dart';
import 'package:skygame_2d/models/unit_assets.dart';
import 'package:skygame_2d/models/unit_render_ext.dart';

// ignore: must_be_immutable
class MatchUnit extends Equatable {
  final int id;
  final Owner owner;
  final Unit character;
  // Live data
  MatchPosition position;
  Species currentSpecies;
  Stats currentStats;
  Stats iStats;
  Stats baseStats;
  Release currentRelease;
  FX currentFX;
  BES currentBES;
  Costs currentCosts;
  final List<Command> actionQ = [];
  final List<EventNotation> eventQ = [];
  final UnitAssets asset;
  final GameManager game;

  // Live Settings
  MatchPosition target;
  final List<MatchPosition> links;

  // Updates
  int incomingDamage;
  int incomingCharge;

  MatchUnit(
    this.character, {
    required this.game,
    required this.owner,
    required this.target,
    required this.position,
    required this.links,
    required this.asset,
  })  : id = game.units.length + 1,
        incomingDamage = 0,
        incomingCharge = 0,
        currentSpecies = character.species,
        currentStats = Stats(
          hp: character.stats[StatType.hp] * 5,
          storage: 0,
          atk: character.stats[StatType.attack],
          def: character.stats[StatType.defense],
          charge: character.stats[StatType.charge],
          exe: character.stats[StatType.execution],
        ),
        iStats = Stats(
          hp: character.stats[StatType.hp] * 5,
          storage: character.stats[StatType.storage] * 4,
          atk: character.stats[StatType.attack],
          def: character.stats[StatType.defense],
          charge: character.stats[StatType.charge],
          exe: character.stats[StatType.execution],
        ),
        baseStats = character.stats,
        currentRelease = character.release,
        currentFX = character.fx,
        currentBES = character.bes,
        currentCosts = character.costs,
        super() {
    game.units.add(this);
  }

  void render(double dt) {
    asset.hud.hpText.text =
        '${currentStats[StatType.hp]} / ${iStats[StatType.hp]}';
    asset.hud.chargeText.text = '${currentStats[StatType.storage]}';
    // TODO: listener
    if (asset.animationState.value.index > UnitAniState.knockback.index) {
      updateHealthBar(dt);
      updateChargeBar(dt);
      updateChargeBarSeparator(dt);
    }
    asset.hud.setOpacity();
  }

  void get resetLiveStatus {
    incomingDamage = 0;
    incomingCharge = 0;
  }

  BrawlType get type => MatchHelper.getBrawlType(position);

  @override
  List<Object?> get props => [
        id,
        owner,
        character,
        target,
        position,
        currentSpecies,
        currentStats,
        currentBES,
        currentCosts,
        currentFX,
        currentRelease,
        iStats,
        baseStats,
      ];
}
