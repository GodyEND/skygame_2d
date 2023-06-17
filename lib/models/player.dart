// import 'package:equatable/equatable.dart';
// import 'package:skygame_2d/game/stage.dart';
// import 'package:skygame_2d/models/unit_assets.dart';
// import 'package:skygame_2d/game/helper.dart';
// import 'package:skygame_2d/game/unit.dart';
// import 'package:skygame_2d/game/game.dart';
// import 'package:skygame_2d/graphics/graphics.dart';
// import 'package:skygame_2d/models/unit.dart';
// import 'package:skygame_2d/models/enums.dart';
// import 'package:skygame_2d/models/unit_hud.dart';



// class Command extends Equatable {
//   final CommandType type;
//   // final String instructions;
//   final Owner owner;
//   final BrawlType user;
//   const Command(this.type, this.owner, this.user);

//   @override
//   List<Object?> get props => [owner, user, type];
// }

// class Player extends Equatable {
//   final Owner owner;
//   PlayerState state = PlayerState.ready;
//   int points;
//   Map<BrawlType, MatchUnit> roster = {};
//   List<MatchPosition> toBeReplaced = [];

//   Player(this.owner, {this.points = 0});

//   void setUnit(GameManager game, BrawlType position, Unit unit) {
//     final unitPos = MatchHelper.getPosRef(owner, position);
//     roster[position] = MatchUnit(
//       unit,
//       game: game,
//       owner: owner,
//       position: unitPos,
//       target: MatchHelper.getDefaultTarget(unitPos),
//       links: const [],
//       asset: _addAssets(unit, unitPos),
//     );
//     roster[position]!.asset.unit = roster[position]!;
//   }

//   @override
//   List<Object?> get props => [];
// }

// UnitAssets _addAssets(Unit unit, MatchPosition unitPos) {
//   return UnitAssets(
//       sprite: GraphicsManager.createUnitSprite(unitPos, unit.image),
//       hud: UnitHUDComponent(
//         profileImage: unit.profile,
//         matchPosition: unitPos,
//         size: Stage.hudResolution,
//       ),
//       infoList: {
//         EXEC_ICON: GraphicsManager.createUnitProfile(unitPos, unit.profile),
//       });
// }
