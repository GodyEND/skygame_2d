import 'package:skygame_2d/abilities/fx.dart';
import 'package:skygame_2d/scenes/combat/bloc/combat/state.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/utils.dart/enums.dart';

abstract class FX {
  final String name;
  final String text;
  final FXType type;
  bool isActive = true;
  void action(MatchUnit user, CombatBlocState state);

  FX(this.name, {required this.type, required this.text}) {
    FXs.add(this);
  }
}

/// MARK: Release Manager
class FXs {
  static final List<FX> _list = [];
  static FX q(String query) {
    return _list.where((q) => q.name == query).first;
  }

  static void add(FX fx) {
    if (!_list.contains(fx)) _list.add(fx);
  }

  static get load {
    FX1();
    FX2();
    FX3();
    FX4();
    FX5();
  }
}
