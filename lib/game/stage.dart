import 'dart:ui';

import 'package:flame/components.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

Vector2 get _lead1Pos => Vector2(400, 850);
Vector2 get _lead2Pos => Vector2(Constants.SCREEN_WIDTH - 400, 850);

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

  static Map<MatchPosition, Vector2> hudPositions(int ownerID) {
    if (ownerID == Constants.FIRST_PLAYER) return _leftHUDPositions;
    return _rightHUDPositions;
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
    CombatPosition.challenger: _lead2Pos,
    CombatPosition.hitbox: _lead1Pos,
  };

  // Left Player Constants
  static final Map<MatchPosition, Vector2> _leftPositions = {
    MatchPosition.lead: _lead1Pos,
    MatchPosition.leftAce:
        _lead1Pos + Vector2(_frontRowSpacingX, -_frontRowSpacingY),
    MatchPosition.rightAce:
        _lead1Pos + Vector2(-_frontRowSpacingX, _frontRowSpacingY),
    MatchPosition.leftLink: _lead1Pos +
        Vector2(_frontRowSpacingX * 0.5, -_frontRowSpacingY * 0.5) -
        Vector2(250, 0),
    MatchPosition.rightLink: _lead1Pos +
        Vector2(_frontRowSpacingX * 0.5, _frontRowSpacingY * 0.5) -
        Vector2(420, 0),
  };
  // Right Player Constants
  static final Map<MatchPosition, Vector2> _rightPositions = {
    MatchPosition.lead: _lead2Pos,
    MatchPosition.leftAce:
        _lead2Pos + Vector2(_frontRowSpacingX, _frontRowSpacingY),
    MatchPosition.rightAce:
        _lead2Pos + Vector2(-_frontRowSpacingX, -_frontRowSpacingY),
    MatchPosition.leftLink: _lead2Pos -
        Vector2(_frontRowSpacingX * 0.5, -_frontRowSpacingY * 0.5) +
        Vector2(420, 0),
    MatchPosition.rightLink: _lead2Pos -
        Vector2(_frontRowSpacingX * 0.5, _frontRowSpacingY * 0.5) +
        Vector2(250, 0),
  };

  static Vector2 get hudResolution =>
      Vector2(Constants.SCREEN_WIDTH * 0.18, 100);
  static Vector2 get hudLeadPos =>
      Vector2(Constants.SCREEN_WIDTH * 0.12, Constants.SCREEN_HEIGHT * 0.12);
  static Vector2 get hudLead2Pos =>
      Vector2(Constants.SCREEN_WIDTH * 0.88, Constants.SCREEN_HEIGHT * 0.12);
  static Map<MatchPosition, Vector2> get _leftHUDPositions => {
        MatchPosition.lead: hudLeadPos,
        MatchPosition.leftAce: hudLeadPos + Vector2(75, -hudResolution.y),
        MatchPosition.rightAce: hudLeadPos + Vector2(-75, hudResolution.y),
        MatchPosition.leftLink:
            hudLeadPos + Vector2(-30, -hudResolution.y + 25),
        MatchPosition.rightLink: hudLeadPos + Vector2(-105, 25),
      };
  static Map<MatchPosition, Vector2> get _rightHUDPositions => {
        MatchPosition.lead: hudLead2Pos,
        MatchPosition.leftAce: hudLead2Pos + Vector2(75, hudResolution.y),
        MatchPosition.rightAce: hudLead2Pos + Vector2(-75, -hudResolution.y),
        MatchPosition.leftLink: hudLead2Pos + Vector2(105, 25),
        MatchPosition.rightLink:
            hudLead2Pos + Vector2(30, -hudResolution.y + 25),
      };
}
