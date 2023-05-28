import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/graphics/graphics.dart';
import 'package:skygame_2d/models/enums.dart';
import 'package:skygame_2d/utils.dart/extensions.dart';

class _ActiveQIcon extends SpriteComponent {
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
    position = Vector2(950, 200);

    // add(RectangleComponent(
    //   anchor: Anchor.center,
    //   size: Vector2(55, 55),
    //   position: Vector2(200, 0),
    //   priority: 6,
    //   paint: Paint()..color = Colors.white.withOpacity(0.4),
    // ));

    // add(RectangleComponent(
    //   anchor: Anchor.center,
    //   size: Vector2(55, 55),
    //   position: Vector2(100, 0),
    //   priority: 6,
    //   paint: Paint()..color = Colors.white.withOpacity(0.2),
    // ));
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
        // (game.prevActive != null) ? [game.prevActive!] : [];
        // result.addAll(
        animatedQ.value.where((e) => MatchHelper.isFrontrow(e.type)).toList();
    // );

    while (result.length < 6) {
      final orderedList = GameManager.executionOrder(game.units)
          .where((e) => MatchHelper.isFrontrow(e.type))
          .toList();
      result.addAll(orderedList);
    }
    return result;
  }

  final Map<int, SpriteComponent> reusable = {};

  Future<void> onQueueChange() async {
    var renderedUnits = _getRenderedUnits;
    final activeIds = renderedUnits.map<int>((e) => e.id).toList();
    final removableIDList = <int>[];
    for (var id in reusable.keys) {
      if (!activeIds.contains(id)) {
        main.remove(reusable[id]!);
        removableIDList.add(id);
      }
    }
    for (var id in removableIDList) {
      reusable.remove(id);
    }

    for (int i = 0; i < min(renderedUnits.length, 6); i++) {
      SpriteComponent? icon;
      bool isNew = false;
      if (i < game.brawlQ.length) {
        // reuse
        // Check if reuse exists
        final currentUnitID = renderedUnits[i].id;
        icon = reusable[currentUnitID];
        if (icon == null) {
          isNew = true;
          icon = GraphicsManager.createUnitProfile(
              renderedUnits[i].position, renderedUnits[i].character.profile);
          reusable[currentUnitID] = icon;
        } else {
          continue;
        }
        // icon.position = main.position + Vector2(i * 100, 50);
      } else {
        isNew = true;
        icon = GraphicsManager.createUnitProfile(
            renderedUnits[i].position, renderedUnits[i].character.profile);
        // icon.position = main.position + Vector2(i * 100, 50);
      }
      // icon = activeComps
      //     .getRange(i, activeComps.length)
      //     .firstWhereOrNull((e) => e.id == renderedUnits[i].id)
      //     ?.comp;
      // }
      // if (isNew) {
      //   final iconPos =
      //       main.position + Vector2(i * 100, 50); // + Vector2(100, 0);
      // }
      icon.position = main.position + Vector2(i * 100, 50);

      icon.anchor = Anchor.center;
      icon.size = Vector2.all(55);
      // icon.position = iconPos;
      if (isNew) {
        final ownerBadge = RectangleComponent(
          anchor: Anchor.center,
          size: Vector2.all(16),
          position: Vector2(28.5, 65),
          paint: Paint()
            ..color =
                renderedUnits[i].owner == Owner.p1 ? Colors.blue : Colors.red,
        );
        icon.add(ownerBadge);
      }

      // final active = RectangleComponent(
      //   anchor: Anchor.center,
      //   size: Vector2.all(70),
      //   position: iconPos + Vector2(0, 0),
      //   priority: 3,
      //   paint: Paint()..color = Colors.green,
      // );
      if (isNew) {
        final eff = MoveEffect.to(
          Vector2(0, 50),
          EffectController(speed: 34),
          onComplete: () {
            if (isNew && reusable.values.contains(icon) == false) {
              icon!.add(RemoveEffect());
            }
            // if (icon!.position.x < main.position.x + 25) {
            // if (i >= game.brawlQ.length) {
//  final copies =
//                 activeComps.getRange(i, activeComps.length).where((e) => e.id == renderedUnits[i].id);
//             activeComps.removeWhere((e) => e.comp == icon);
            // icon.add(RemoveEffect(delay: 0));
            // }
          },
        );
        icon.add(eff);
      }

      // final eff2 = MoveEffect.by(
      //   Vector2(-100, 0),
      //   EffectController(duration: 3),
      //   onComplete: () {
      //     if (ownerBadge.position.x < main.position.x) {
      //       ownerBadge.add(RemoveEffect(delay: 0));
      //     }
      //   },
      // );

      // ownerBadge.setOpacity((i < 5) ? (5 - i < 2 ? 0 : i) / 5 + 0.1 : 0);

      // if (i < 5) {
      //   final opEff =
      //       OpacityEffect.to((5 - (i - 1)) / 6, EffectController(duration: 3));
      //   opEff.removeOnFinish = true;
      //   ownerBadge.add(opEff);
      // }
      // if (i == 1) {
      //   icon.add(active);
      // }
      // if (icon.position.x > main.position.x + 25) {
      //   final existingEff =
      //       icon.children.firstWhereOrNull((e) => e is MoveEffect);
      //   if (existingEff != null) {
      //     final existProg = (existingEff as MoveEffect).controller.progress;
      //     DelayedEffectController(eff.controller, delay: 3 * (1 - existProg));
      //   }
      //   icon.add(eff);
      // }
      // ownerBadge.add(eff2);
      if (isNew) {
        // activeComps.add(_ActiveQIcon(renderedUnits[i].id, icon));
        main.add(icon);
      }
    }
  }
}
