import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skygame_2d/characters/angelos/angelos.dart';
import 'package:skygame_2d/game/combat_ui/brawl_q.dart';
import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/models/enums.dart';
import 'package:skygame_2d/models/fx.dart';
import 'package:skygame_2d/models/player.dart';
import 'package:skygame_2d/models/release.dart';
import 'package:skygame_2d/models/unit.dart';
import 'package:skygame_2d/setup.dart';

void main() async {
  GameManager game = GameManager(SkyGame2D());
  Player p1 = Player(Owner.p1);
  WidgetsFlutterBinding.ensureInitialized();

  await Sprites.loadImages();
  Releases.load;
  FXs.load;
  Units.load;

  final char1 = Angelos1();
  final char2 = Angelos2();
  final char3 = Angelos3();
  final char4 = Angelos4();
  final char5 = Angelos5();

  setUp(() async {
    game.units.clear();
    p1.matchUnits.clear();
    game.brawlQ.clear();
    game.prevBrawlQ.value.clear();
    p1.setUnit(game, BrawlType.lead, char1);
    p1.setUnit(game, BrawlType.leftAce, char2);
    p1.setUnit(game, BrawlType.rightAce, char3);
    p1.setUnit(game, BrawlType.leftLink, char4);
    p1.setUnit(game, BrawlType.rightLink, char5);
    p1.setUnit(game, BrawlType.reserve1, char5);
    p1.setUnit(game, BrawlType.reserve2, char5);

    game.units = [
      p1.matchUnits[BrawlType.rightAce]!,
      p1.matchUnits[BrawlType.lead]!,
      p1.matchUnits[BrawlType.leftAce]!,
      p1.matchUnits[BrawlType.leftLink]!,
      p1.matchUnits[BrawlType.rightLink]!,
      p1.matchUnits[BrawlType.reserve1]!,
      p1.matchUnits[BrawlType.reserve2]!,
    ];
  });
  group('Brawl Q', () {
    test('q components count', () async {
      final qComp = BrawlQComponent(game, game.prevBrawlQ);
      int childCount = qComp.main.children.length;
      expect(childCount, 0);
      await qComp.onLoad();
      game.updateActive;
      childCount = qComp.main.children.length;
      expect(childCount, 12);
      // Updated
      game.updateActive;
      game.updateActive;
      await Future.delayed(const Duration(seconds: 3));
      expect(childCount, 12);
    });

    test('q components count with single matchunit', () async {
      final qComp = BrawlQComponent(game, game.prevBrawlQ);
      int childCount = qComp.main.children.length;
      expect(childCount, 0);
      await qComp.onLoad();
      game.updateActive;
      // childCount = qComp.main.children.length;
      // expect(childCount, 12);
      // Updated
      // game.updateActive;
      // game.updateActive;
      // await Future.delayed(const Duration(seconds: 3));
      // expect(childCount, 12);

      // Defeated
      p1.matchUnits[BrawlType.leftAce]!.position = MatchPosition.defeated;
      p1.matchUnits[BrawlType.rightAce]!.position = MatchPosition.defeated;
      game.updateActive;
      game.updateActive;
      game.updateActive;
      expect(game.brawlQ.length, 1);
      qComp.update(0.3);
      await Future.delayed(const Duration(seconds: 3));
      childCount = qComp.main.children.length;

      expect(childCount, 12);
    });
  });
}
