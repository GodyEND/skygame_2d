import 'dart:ui';

import 'package:flame/components.dart';
import 'package:skygame_2d/models/enums.dart';

class Stage {
  final String name;
  final Image bg;
  static final Map<MatchPosition, Vector2> positions = {
    MatchPosition.p1Lead: Vector2(520, 820),
    MatchPosition.p1LeftAce: Vector2(650, 750),
    MatchPosition.p1RightAce: Vector2(390, 890),
    MatchPosition.p1LeftLink: Vector2(400, 785),
    MatchPosition.p1RightLink: Vector2(270, 855),
    MatchPosition.p2Lead: Vector2(1380, 820),
    MatchPosition.p2LeftAce: Vector2(1510, 890),
    MatchPosition.p2RightAce: Vector2(1250, 750),
    MatchPosition.p2LeftLink: Vector2(1650, 855),
    MatchPosition.p2RightLink: Vector2(1520, 785),
    MatchPosition.p1Combatant: Vector2(735, 820),
    MatchPosition.p2Combatant: Vector2(1165, 820),
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
