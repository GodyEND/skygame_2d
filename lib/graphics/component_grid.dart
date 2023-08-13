import 'dart:math';
import 'dart:core';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:skygame_2d/models/components/selectable.dart';
import 'package:skygame_2d/utils.dart/constants.dart';
import 'package:skygame_2d/utils.dart/extensions.dart';

enum SelectedChangeType { up, down, none }

class ComponentGrid extends ClipComponent {
  final Axis scrollDirection;
  final int itemsPerSet;
  late final double _scrollViewSize;
  late final PositionComponent scrollView;
  late final Vector2 _padding;
  late final List<PositionComponent> _children;

  ComponentGrid({
    required List<PositionComponent> children,
    required Vector2 size,
    required Vector2 position,
    this.scrollDirection = Axis.horizontal,
    required this.itemsPerSet,
    super.priority,
    Vector2? padding,
  })  : assert(itemsPerSet > 0),
        _padding = padding ?? Vector2.all(0.0),
        _children = children,
        super(
            size: size,
            position: position,
            builder: (Vector2 shape) => Rectangle.fromRect(
                Rect.fromLTWH(position.x, position.y, size.x, size.y)));

  @override
  Future<void> onLoad() async {
    scrollView = RectangleComponent(
        position: Vector2(0, 0),
        size: size,
        children: _children,
        paint: Paint()..color = Colors.transparent);
    await add(scrollView);

    Vector2 prevMaxSize = Vector2.all(0.0);
    Vector2 gridMaxSize = Vector2.all(0.0);
    List<Vector2> childMaxSize =
        List.filled((_children.length / itemsPerSet).ceil(), Vector2.all(0.0));

    for (int i = 0; i < _children.length; i++) {
      final rowIndex = (i / itemsPerSet).floor();
      prevMaxSize += _children[i].size + _padding;
      childMaxSize[rowIndex] = Vector2(
          max(_children[i].size.x, childMaxSize[rowIndex].x),
          max(_children[i].size.y, childMaxSize[rowIndex].y));

      if (i % itemsPerSet == itemsPerSet - 1 || i == _children.length - 1) {
        childMaxSize[rowIndex] += _padding;
        gridMaxSize.x = max(prevMaxSize.x, gridMaxSize.x);
        gridMaxSize.y = max(prevMaxSize.y, gridMaxSize.y);
        prevMaxSize = Vector2.all(0.0);
      }
    }

    _scrollViewSize = (_children.length / itemsPerSet).ceil() *
            (scrollDirection == Axis.horizontal
                ? gridMaxSize.x
                : gridMaxSize.y) +
        ((scrollDirection == Axis.horizontal) ? _padding.x : _padding.y);

    scrollView.size = scrollDirection != Axis.horizontal
        ? Vector2(size.x, _scrollViewSize)
        : Vector2(_scrollViewSize, size.y);

    _updatePosition();
    return super.onLoad();
  }

  void _updatePosition() {
    List<Vector2> childMaxSize =
        List.filled((_children.length / itemsPerSet).ceil(), Vector2.all(0.0));

    for (int i = 0; i < _children.length; i++) {
      final rowIndex = (i / itemsPerSet).floor();
      childMaxSize[rowIndex] = Vector2(
          max(_children[i].size.x, childMaxSize[rowIndex].x),
          max(_children[i].size.y, childMaxSize[rowIndex].y));

      if (i % itemsPerSet == itemsPerSet - 1 || i == _children.length - 1) {
        childMaxSize[rowIndex] += _padding;
      }
    }

    final localZeroVec = scrollView.parentToLocal(position) + _padding;
    Vector2 startPos = localZeroVec;

    for (int i = 0; i < _children.length; i++) {
      final rowIndex = (i / itemsPerSet).floor();

      _children[i].position =
          startPos + centeringOffset(_children[i], childMaxSize[rowIndex]);

      if (i % itemsPerSet == itemsPerSet - 1 || i == _children.length - 1) {
        startPos = scrollDirection == Axis.vertical
            ? Vector2(
                localZeroVec.x,
                localZeroVec.y +
                    ((i + 1) / itemsPerSet).floor() * childMaxSize[rowIndex].y)
            : Vector2(
                localZeroVec.x +
                    ((i + 1) / itemsPerSet).floor() * childMaxSize[rowIndex].x,
                localZeroVec.y);
      } else {
        startPos = (scrollDirection == Axis.vertical
            ? Vector2(startPos.x + _children[i].size.x + _padding.x, startPos.y)
            : Vector2(
                startPos.x, startPos.y + _children[i].size.y + _padding.y));
      }
    }
  }

  Vector2 centeringOffset(PositionComponent child, Vector2 childMaxSize) {
    final centerMaxSize = (size / itemsPerSet.toDouble());
    final double? diff = (scrollDirection == Axis.vertical)
        ? ((centerMaxSize.x > childMaxSize.x)
            ? (centerMaxSize.x - childMaxSize.x) * 0.5
            : null)
        : ((centerMaxSize.y > childMaxSize.y)
            ? (centerMaxSize.y - childMaxSize.y) * 0.5
            : null);
    final defaultDiff = (childMaxSize - (child.size + _padding)) * 0.5;
    return (scrollDirection == Axis.vertical)
        ? Vector2(diff ?? defaultDiff.x, 0.0)
        : Vector2(0.0, defaultDiff.y);
  }

  SelectableSprite? prevSelected;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // scrollTo selected index
    final selectedItem = scrollView.children.firstWhereOrNull(
            (e) => e is SelectableSprite ? e.isSelected : false)
        as SelectableSprite?;
    if (scrollView.children.isEmpty) return;
    // final firstItem = scrollView.children
    //     .firstWhereOrNull((e) => e is SelectableSprite) as SelectableSprite?;
    // final lastItem = scrollView.children
    //     .lastWhereOrNull((e) => e is SelectableSprite) as SelectableSprite?;

    if (selectedItem == null) return;
    final scrollsHorizontally = scrollDirection == Axis.horizontal;
    // final offset = selectedItem.position - _padding;
    // final target =
    //     !scrollsHorizontally ? Vector2(0, offset.y) : Vector2(offset.x, 0);

    // final current = _scrollViewSize *
    //         (scrollsHorizontally
    //             ? scrollView.position.x.abs()
    //             : scrollView.position.y.abs()) /
    //         _scrollViewSize +
    //     (scrollsHorizontally ? position.x : position.y);

    // start point & range length
    // final visibleRange = scrollsHorizontally
    //     ? Vector2(current, position.x + size.x)
    //     : Vector2(current, position.y + size.y);

    // TODO:
    // Define Visible area
    Rect visibleRegion = Rect.fromLTWH(scrollView.position.x.abs(),
        scrollView.position.y.abs(), size.x, size.y);
    // Define scrollDirection ///
    // Define last and first item

    bool isVisible = isWithinVisibleRegion(visibleRegion, selectedItem);
    // bool firstIsVisible = false;
    // bool lastIsVisible = false;
    SelectedChangeType scrollType = SelectedChangeType.none;

    // if (firstItem != null && isWithinVisibleRegion(visibleRegion, firstItem)) {
    //   firstIsVisible = true;
    // }
    // if (lastItem != null && isWithinVisibleRegion(visibleRegion, lastItem)) {
    //   lastIsVisible = true;
    // }

    if (!isVisible && selectedItem != prevSelected && prevSelected != null) {
      scrollType = (scrollDirection == Axis.vertical &&
                  selectedItem.position.y > prevSelected!.position.y ||
              scrollDirection == Axis.horizontal &&
                  selectedItem.position.x > prevSelected!.position.x)
          ? SelectedChangeType.down
          : SelectedChangeType.up;
    }

    if (!isVisible) {
      if (scrollsHorizontally) {
        final moveTarget = /*min(position.x,*/
            /*position.x - */ -selectedItem.position.x;
        scrollView.position.moveToTarget(
            Vector2(moveTarget, position.y), 144.0 * Constants.ANI_SPEED);
        // if (scrollType == SelectedChangeType.down) {
        //   final moveTarget = /*max(-size.x,*/
        //       position.x - size.x - (selectedItem.position.x + _padding.x); //);
        //   scrollView.position.moveToTarget(
        //       Vector2(moveTarget, position.y), 144.0 * Constants.ANI_SPEED);
        // }
        // if (scrollType == SelectedChangeType.up) {
        //   final moveTarget = /*min(position.x,*/
        //       /*position.x - */selectedItem.position.x;// + selectedItem.size.x; //);
        //   scrollView.position.moveToTarget(
        //       Vector2(moveTarget, position.y), 144.0 * Constants.ANI_SPEED);
        // }
      } else {
        final moveTarget = (scrollType == SelectedChangeType.down)
            ? max(-size.y,
                position.y - size.y - (selectedItem.position.y + _padding.y))
            : min(position.y,
                position.y - selectedItem.position.y + selectedItem.size.y);
        scrollView.position.moveToTarget(
            Vector2(position.x, moveTarget), 144.0 * Constants.ANI_SPEED);
      }
    }
    if (prevSelected != selectedItem) {
      prevSelected = selectedItem;
    }
  }

  bool isWithinVisibleRegion(Rect visible, SelectableSprite target) {
    if (target.x >= visible.left &&
        target.x + target.size.x + _padding.x <= visible.left + visible.width &&
        target.y >= visible.top &&
        target.y + target.size.y + _padding.y <= visible.top + visible.height) {
      return true;
    }
    return false;
  }
}
