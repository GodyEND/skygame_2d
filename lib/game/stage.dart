import 'dart:ui';

import 'package:flame/components.dart';
import 'package:skygame_2d/models/enums.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

Vector2 get _lead1Pos =>
    Vector2(Constants.SCREEN_WIDTH * 0.22, Constants.SCREEN_HEIGHT * 0.78);
Vector2 get spriteHeight => Vector2.all(Constants.SCREEN_HEIGHT * 0.05);
Vector2 get frontRowSpace =>
    Vector2(spriteHeight.x + spriteHeight.y * 2, -spriteHeight.y);

class Stage {
  final String name;
  final Image bg;
  static final Map<MatchPosition, Vector2> positions = {
    MatchPosition.p1Lead: _lead1Pos,
    MatchPosition.p1LeftAce: _lead1Pos + frontRowSpace,
    MatchPosition.p1RightAce: _lead1Pos - frontRowSpace,
    MatchPosition.p1LeftLink: _lead1Pos +
        Vector2(frontRowSpace.x * 0.5, frontRowSpace.y * 0.5) -
        Vector2(4 * spriteHeight.x, spriteHeight.y * 0.5),
    MatchPosition.p1RightLink: _lead1Pos +
        Vector2(frontRowSpace.x * 0.5, frontRowSpace.y * 0.5) -
        Vector2(4 * spriteHeight.x, spriteHeight.y * 0.5) -
        frontRowSpace,
    MatchPosition.p2Lead:
        Vector2(Constants.SCREEN_WIDTH, 0) - Vector2(_lead1Pos.x, -_lead1Pos.y),
    MatchPosition.p2LeftAce: Vector2(Constants.SCREEN_WIDTH, 0) -
        Vector2(_lead1Pos.x, -_lead1Pos.y) -
        Vector2(-frontRowSpace.x, frontRowSpace.y),
    MatchPosition.p2RightAce: Vector2(Constants.SCREEN_WIDTH, 0) -
        Vector2(_lead1Pos.x, -_lead1Pos.y) -
        Vector2(frontRowSpace.x, -frontRowSpace.y),
    MatchPosition.p2LeftLink: Vector2(Constants.SCREEN_WIDTH, 0) -
        (Vector2(_lead1Pos.x, -_lead1Pos.y) +
            Vector2(frontRowSpace.x * 0.5, -frontRowSpace.y * 0.5) -
            Vector2(4 * spriteHeight.x, -spriteHeight.y * 0.5) -
            Vector2(frontRowSpace.x, -frontRowSpace.y)),
    MatchPosition.p2RightLink: Vector2(Constants.SCREEN_WIDTH, 0) -
        (Vector2(_lead1Pos.x, -_lead1Pos.y) +
            Vector2(frontRowSpace.x * 0.5, -frontRowSpace.y * 0.5) -
            Vector2(4 * spriteHeight.x, -spriteHeight.y * 0.5)),
    MatchPosition.p1Combatant:
        _lead1Pos + Vector2(Constants.SCREEN_WIDTH * 0.12, 0),
    MatchPosition.p2Combatant: Vector2(Constants.SCREEN_WIDTH, 0) -
        Vector2(_lead1Pos.x, -_lead1Pos.y) -
        Vector2(Constants.SCREEN_WIDTH * 0.12, 0),
    MatchPosition.p1HitBox:
        Vector2(Constants.SCREEN_CENTER.x - spriteHeight.x * 0.55, _lead1Pos.y),
    MatchPosition.p2HitBox:
        Vector2(Constants.SCREEN_CENTER.x + spriteHeight.x * 0.55, _lead1Pos.y),
  };

  static final Map<MatchPosition, Vector2> hudPositions = {
    MatchPosition.p1Lead: Vector2(150, 200),
    MatchPosition.p1LeftAce: Vector2(200, 100),
    MatchPosition.p1RightAce: Vector2(100, 300),
    MatchPosition.p1LeftLink: Vector2(100, 105),
    MatchPosition.p1RightLink: Vector2(50, 205),
    MatchPosition.p2Lead: Vector2(1770, 200),
    MatchPosition.p2LeftAce: Vector2(1820, 300),
    MatchPosition.p2RightAce: Vector2(1720, 100),
    MatchPosition.p2LeftLink: Vector2(1870, 205),
    MatchPosition.p2RightLink: Vector2(1820, 105),
    // MatchPosition.p1Combatant: Vector2(735, 820),
    // MatchPosition.p2Combatant: Vector2(1165, 820),
  };

  Stage(this.name, this.bg);
}
