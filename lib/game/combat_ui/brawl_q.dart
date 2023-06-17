import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/graphics/graphics.dart';
import 'package:skygame_2d/utils.dart/constants.dart';
import 'package:skygame_2d/utils.dart/extensions.dart';

class _ActiveQIcon {
  final int id;
  final SpriteComponent comp;
  _ActiveQIcon(this.id, this.comp);
}

class BrawlQComponent extends PositionComponent {
  final ValueNotifier<List<MatchUnit>> animatedQ;
  final GameManager game;

  BrawlQComponent(this.game, this.animatedQ) {
    add(main);
    add(RectangleComponent(
      anchor: Anchor.center,
      size: Vector2(500, 12),
      paint: Paint()..color = Colors.white,
    ));
    position = Vector2(Constants.SCREEN_CENTER.x, 200);

    onQueueChange();
  }

  final ClipComponent main = ClipComponent(
    builder: (region) {
      return Rectangle.fromRect(const Rect.fromLTWH(0, 0, 500, 120));
    },
    anchor: Anchor.center,
    priority: 5,
    size: Vector2(500, 100),
  );

  @override
  FutureOr<void> onLoad() {
    animatedQ.addListener(onQueueChange);
    return super.onLoad();
  }

  List<MatchUnit> get _getRenderedUnits {
    final List<MatchUnit> result =
        animatedQ.value.where((e) => MatchHelper.isFrontrow(e.type)).toList();

    while (result.length < 7) {
      final orderedList = GameManager.executionOrder(game.units)
          .where((e) => MatchHelper.isFrontrow(e.type))
          .toList();
      result.addAll(orderedList);
    }
    return result;
  }

  final Map<int, SpriteComponent> reusable = {};
  // ignore: library_private_types_in_public_api
  List<_ActiveQIcon> activeComps = [];

  Future<void> onQueueChange() async {
    var renderedUnits = _getRenderedUnits;
    final activeIds = renderedUnits.map<int>((e) => e.id).toList();
    final removableComps = <_ActiveQIcon>[];
    for (var active in activeComps) {
      if (active.comp.position.x <= main.position.x - 25) {
        removableComps.add(active);
        main.remove(active.comp);
      } else if (!activeIds.contains(active.id) &&
          !removableComps.contains(active)) {
        removableComps.add(active);
        main.remove(active.comp);
      }
    }
    for (var removable in removableComps) {
      activeComps.remove(removable);
    }
    removableComps.clear();

    List<_ActiveQIcon?> orderedComps = [];
    for (int j = 0; j < renderedUnits.length; j++) {
      orderedComps.add(activeComps.firstWhereOrNull((e) =>
          e.id == renderedUnits[j].id && orderedComps.contains(e) == false));
    }

    activeComps =
        List<_ActiveQIcon>.from(orderedComps.where((e) => e != null).toList());
    for (int i = 0;
        i < min(renderedUnits.length, Constants.COMBAT_Q_LENGTH);
        i++) {
      final currentUnitID = renderedUnits[i].id;
      final idOcc =
          renderedUnits.where((e) => e.id == currentUnitID).toList().length;
      final activeIDOcc =
          activeComps.where((e) => e.id == currentUnitID).toList().length;

      if (activeComps.length > i && activeComps[i].id == currentUnitID) {
        if (activeComps[i].comp.position.x > main.position.x + i * 100) {
          activeComps[i].comp.position = main.position + Vector2(i * 100, 50);
        }
        continue;
      } else if (idOcc <= activeIDOcc) {
        final modComp = activeComps
            .getRange(i, activeComps.length)
            .toList()
            .firstWhereOrNull((e) => e.id == currentUnitID);
        if (modComp != null) {
          modComp.comp.position = main.position + Vector2(i * 100, 50);
          final removableRange =
              activeComps.getRange(i, activeComps.indexOf(modComp)).toList();
          for (int j = 0; j < removableRange.length; j++) {
            removableComps.add(removableRange[j]);
          }
          for (var removable in removableComps) {
            if (main.contains(removable.comp)) {
              main.remove(removable.comp);
            }
            activeComps.remove(removable);
          }
        } else {
          _addNewIcon(renderedUnits[i], Vector2(i * 100, 50));
        }
      } else {
        _addNewIcon(renderedUnits[i], Vector2(i * 100, 50));
      }
    }
    if (activeComps.length != Constants.COMBAT_Q_LENGTH) {
      final currentIDs = activeComps.map<int>((e) => e.id).toList();
      currentIDs.sort();
      final finalIDs =
          activeIds.getRange(0, Constants.COMBAT_Q_LENGTH).toList();
      finalIDs.sort();
      int redoCounter = 0;
      for (int i = 0; i < currentIDs.length; i++) {
        if (i - redoCounter >= finalIDs.length ||
            currentIDs[i] != finalIDs[i - redoCounter]) {
          final removable =
              activeComps.firstWhere((e) => e.id == currentIDs[i]);
          if (main.contains(removable.comp)) {
            main.remove(removable.comp);
          }
          activeComps.remove(removable);
          redoCounter += 1;
        }
      }
    }
  }

  _addNewIcon(MatchUnit unit, Vector2 offset) {
    final icon = GraphicsManager.createUnitProfile(
        unit.position, unit.character.profile);
    icon.position = main.position + offset;
    icon.anchor = Anchor.center;
    icon.size = Vector2.all(55);

    final ownerBadge = RectangleComponent(
      anchor: Anchor.center,
      size: Vector2.all(16),
      position: Vector2(28.5, 65),
      paint: Paint()
        ..color = MatchHelper.isLeftTeam(unit) ? Colors.blue : Colors.red,
    );
    icon.add(ownerBadge);

    final eff = MoveEffect.to(
      Vector2(-30, 50),
      // TODO: use dt
      EffectController(speed: 34.0 * Constants.ANI_SPEED.toDouble()),
    );
    icon.add(eff);

    activeComps.add(_ActiveQIcon(unit.id, icon));
    main.add(icon);
  }
}
