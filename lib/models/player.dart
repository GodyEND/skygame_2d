import 'package:equatable/equatable.dart';
import 'package:skygame_2d/models/unit_assets.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/graphics/graphics.dart';
import 'package:skygame_2d/models/unit.dart';
import 'package:skygame_2d/models/enums.dart';

enum MatchState { setup, base, replace, end }

enum CommandType {
  normalAtk,
  guard,
  retreat,
  swap,
  releaseAtk,
  target,
  autoGuard,
  autoRelease
}

class Command extends Equatable {
  final CommandType type;
  // final String instructions;
  final Owner owner;
  final BrawlType user;
  const Command(this.type, this.owner, this.user);

  @override
  List<Object?> get props => [owner, user, type];
}

class Player {
  final Owner owner;

  Map<BrawlType, MatchUnit> matchUnits = {};
  int points;
  MatchUnit? toBeReplaced;
  MatchPosition? confirmedReplacement;
  PlayerState state = PlayerState.ready;
  final List<MatchUnit> swappedUnits = [];

  Player(this.owner, {this.points = 0});

  void setUnit(GameManager game, BrawlType position, Unit unit) {
    final unitPos = MatchHelper.getPosRef(owner, position);
    matchUnits[position] = MatchUnit(
      unit,
      game: game,
      owner: owner,
      position: unitPos,
      target: MatchHelper.getDefaultTarget(unitPos),
      links: [],
      asset: _addAssets(game, unit, unitPos),
    );
    matchUnits[position]!.asset.unit = matchUnits[position]!;
  }
}

UnitAssets _addAssets(GameManager game, Unit unit, MatchPosition unitPos) {
  return UnitAssets(
      sprite: GraphicsManager.createUnitSprite(unitPos, unit.image),
      // profile: GraphicsManager.createUnitProfile(unitPos, unit.profile),
      // healthbar: GraphicsManager.createHealthBar(unitPos),
      // healthbarBG: GraphicsManager.createHealthBarBG(unitPos),
      // chargebar: GraphicsManager.createChargeBar(unitPos),

      infoList: {
        DAMAGE_TEXT: GraphicsManager.createHPHUDText(unitPos),
        CHARGE_TEXT: GraphicsManager.createChargeHUDText(unitPos),
        EXEC_ICON: GraphicsManager.createUnitProfile(unitPos, unit.profile),
      });
}
