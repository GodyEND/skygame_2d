import 'dart:ui';

import 'package:flame/components.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

Vector2 get _lead1Pos => Vector2(400, 700);
Vector2 get _lead2Pos => Vector2(680, 700);

const double _topRowY = 200;
const double _midRowY = 300;
const double _bottomRowY = 400;
const double _challengeX = 400;
const double _hitX = 600;
const double _frontRowSpacingX = 200;
const double _frontRowSpacingY = 100;
const double _backRowSpacingY = 50;

class Stage {
  final String name;
  final Image bg;
  Stage(this.name, this.bg);

  static Map<MatchPosition, Vector2> positions(int ownerID) {
    if (ownerID == Constants.FIRST_PLAYER) return _leftPositions;
    return _rightPositions;
  }

  static Map<CombatPosition, Vector2> zones(int ownerID) {
    if (ownerID == Constants.FIRST_PLAYER) return _leftZones;
    return _rightZones;
  }

  static final Map<CombatPosition, Vector2> _leftZones = {
    CombatPosition.challenger: _lead1Pos,
    CombatPosition.hitbox: _lead1Pos,
  };

  static final Map<CombatPosition, Vector2> _rightZones = {
    CombatPosition.challenger: _lead1Pos,
    CombatPosition.hitbox: _lead1Pos,
  };

  // Left Player Constants
  static final Map<MatchPosition, Vector2> _leftPositions = {
    MatchPosition.lead: _lead1Pos,
    MatchPosition.leftAce:
        _lead1Pos + Vector2(_frontRowSpacingX, -_frontRowSpacingY),
    MatchPosition.rightAce:
        _lead1Pos + Vector2(-_frontRowSpacingX, _frontRowSpacingY),
    // MatchPosition.leftLink: _lead1Pos +
    //     Vector2(frontRowSpace.x * 0.5, frontRowSpace.y * 0.5) -
    //     Vector2(4 * spriteHeight.x, spriteHeight.y * 0.5),
    // MatchPosition.rightLink: _lead1Pos +
    //     Vector2(frontRowSpace.x * 0.5, frontRowSpace.y * 0.5) -
    //     Vector2(4 * spriteHeight.x, spriteHeight.y * 0.5) -
    //     frontRowSpace,
  };
  // Right Player Constants

  static final Map<MatchPosition, Vector2> _rightPositions = {
    MatchPosition.lead: _lead2Pos,
    MatchPosition.leftAce:
        _lead2Pos + Vector2(_frontRowSpacingX, _frontRowSpacingY),
    MatchPosition.rightAce:
        _lead2Pos + Vector2(-_frontRowSpacingX, -_frontRowSpacingY),
    // MatchPosition.leftLink: _lead2Pos +
    //     Vector2(frontRowSpace.x * 0.5, frontRowSpace.y * 0.5) -
    //     Vector2(4 * spriteHeight.x, spriteHeight.y * 0.5),
    // MatchPosition.rightLink: _lead1Pos +
    //     Vector2(frontRowSpace.x * 0.5, frontRowSpace.y * 0.5) -
    //     Vector2(4 * spriteHeight.x, spriteHeight.y * 0.5) -
    //     frontRowSpace,
  };

  static Vector2 get hudResolution =>
      Vector2(Constants.SCREEN_WIDTH * 0.18, 100);
  static Vector2 get hudLeadPos =>
      Vector2(Constants.SCREEN_WIDTH * 0.12, Constants.SCREEN_HEIGHT * 0.12);
  static Vector2 get hudLead2Pos =>
      Vector2(Constants.SCREEN_WIDTH * 0.88, Constants.SCREEN_HEIGHT * 0.12);
  static Map<MatchPosition, Vector2> get hudPositions => {
        MatchPosition.lead: hudLeadPos,
        MatchPosition.leftAce: hudLeadPos + Vector2(75, -hudResolution.y),
        MatchPosition.rightAce: hudLeadPos + Vector2(-75, hudResolution.y),
        MatchPosition.leftLink:
            hudLeadPos + Vector2(-30, -hudResolution.y + 25),
        MatchPosition.rightLink: hudLeadPos + Vector2(-105, 25),
        MatchPosition.lead: hudLead2Pos,
        MatchPosition.leftAce: hudLead2Pos + Vector2(75, hudResolution.y),
        MatchPosition.rightAce: hudLead2Pos + Vector2(-75, -hudResolution.y),
        MatchPosition.leftLink: hudLead2Pos + Vector2(105, 25),
        MatchPosition.rightLink:
            hudLead2Pos + Vector2(30, -hudResolution.y + 25),
        // MatchPosition.p1Combatant: Vector2(735, 820),
        // MatchPosition.p2Combatant: Vector2(1165, 820),
      };
}
