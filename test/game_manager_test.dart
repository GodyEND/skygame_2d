import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skygame_2d/characters/angelos/angelos.dart';
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
    test('exec order', () {
      game.brawlQ.addAll(GameManager.executionOrder(game.units));

      expect(game.brawlQ, [
        p1.matchUnits[BrawlType.rightAce],
        p1.matchUnits[BrawlType.lead],
        p1.matchUnits[BrawlType.leftAce],
      ]);

      // prev order isEmpty
      expect(game.prevBrawlQ.value, []);
    });

    test('prev exec order', () {
      game.brawlQ.addAll(GameManager.executionOrder(game.units));
      final firstOrder = [
        p1.matchUnits[BrawlType.rightAce],
        p1.matchUnits[BrawlType.lead],
        p1.matchUnits[BrawlType.leftAce],
      ];
      final secondOrder = [
        p1.matchUnits[BrawlType.lead],
        p1.matchUnits[BrawlType.leftAce],
      ];

      expect(game.brawlQ, firstOrder);

      // prev order isEmpty
      game.updateActive;

      expect(game.brawlQ, secondOrder);
      expect(game.prevBrawlQ.value, firstOrder);
    });

    test('prev exec order with no active', () {
      game.brawlQ.addAll(GameManager.executionOrder(game.units));
      final firstOrder = [
        p1.matchUnits[BrawlType.rightAce],
        p1.matchUnits[BrawlType.lead],
        p1.matchUnits[BrawlType.leftAce],
      ];
      final prevOrder = [
        p1.matchUnits[BrawlType.leftAce],
        p1.matchUnits[BrawlType.rightAce],
        p1.matchUnits[BrawlType.lead],
        p1.matchUnits[BrawlType.leftAce],
      ];

      game.updateActive;
      game.updateActive;
      game.updateActive;

      expect(game.brawlQ, firstOrder);
      expect(game.prevBrawlQ.value, prevOrder);
    });

    test('exec order on defeat', () {
      game.brawlQ.addAll(GameManager.executionOrder(game.units));
      final firstOrder = [
        p1.matchUnits[BrawlType.rightAce],
        p1.matchUnits[BrawlType.lead],
        p1.matchUnits[BrawlType.leftAce],
      ];

      final expectedOrder = [
        p1.matchUnits[BrawlType.leftAce],
      ];

      expect(game.brawlQ, firstOrder);

      // Next in Q defeated
      p1.matchUnits[BrawlType.lead]!.position = MatchPosition.defeated;
      game.updateActive;

      expect(game.brawlQ, expectedOrder);
    });

    test('turn counter', () {
      game.brawlQ.addAll(GameManager.executionOrder(game.units));
      expect(game.turn, 1);

      final qFullLength = game.brawlQ.length;

      for (int i = 0; i < 99; i++) {
        for (int j = 0; j < qFullLength; j++) {
          game.updateActive;
        }
      }
      expect(game.turn, 100);
    });
  });
}
