import 'dart:async';

import 'package:flame/components.dart';
import 'package:skygame_2d/main.dart';

class ManagedScene extends Component with HasGameRef<SkyGame2D> {
  final List<Component> sceneComponents = [];
  FutureOr<void> addToScene(Component component) async {
    sceneComponents.add(component);
    await add(component);
  }

  FutureOr<void> clearScene() async {
    for (var component in sceneComponents) {
      component.removeFromParent();
    }
  }
}
