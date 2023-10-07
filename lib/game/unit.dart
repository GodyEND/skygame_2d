import 'package:equatable/equatable.dart';
import 'package:skygame_2d/game/trackers.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/models/match_unit/match_unit_data.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/models/match_unit/unit_assets.dart';
import 'package:skygame_2d/models/match_unit/unit_render_ext.dart';
import 'package:skygame_2d/models/stats.dart';

// ignore: must_be_immutable
class MatchUnit extends Equatable {
  final int id;
  final int ownerID;
  final Unit character;
  final Stats baseStats;
  final MatchUnitData current;
  final MatchUnitData initial;

  // Release currentRelease;
  final List<EventNotation> eventQ = [];

  // Live Settings
  MatchPosition position;
  MatchPosition target;
  final List<MatchPosition> links;
  // UI representation
  /// DO NOT manipulate outside of extension
  MatchUnitAssets? protectedAsset;

  // Updates
  int incomingDamage;
  int incomingCharge;

  MatchUnit(
    this.character, {
    required this.id,
    required this.ownerID,
    required this.target,
    required this.links,
    required this.position,
  })  : incomingDamage = 0,
        incomingCharge = 0,
        current = MatchUnitData(character: character)
          ..stats.values[StatType.storage] = 0,
        initial = MatchUnitData(character: character),
        baseStats = character.stats,
        super();

  void render(double dt) {
    asset.hud.hpText.text =
        '${current.stats[StatType.hp]} / ${initial.stats[StatType.hp]}';
    asset.hud.chargeText.text = '${current.stats[StatType.storage]}';
    // TODO: listener
    // if (asset.animationState.value.index > UnitAniState.knockback.index) {
    updateHealthBar(dt);
    updateChargeBar(dt);
    updateChargeBarSeparator(dt);
    // }
    asset.hud.setOpacity();
  }

  void get resetLiveStatus {
    incomingDamage = 0;
    incomingCharge = 0;
  }

  @override
  List<Object?> get props => [
        id,
        ownerID,
        character,
        position,
        target,
        current,
        initial,
        baseStats,
        protectedAsset,
      ];

  MatchUnitAssets get asset {
    if (protectedAsset == null) throw Exception('Must set MatchUnit asset');
    return protectedAsset!;
  }
}
