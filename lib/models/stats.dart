import 'package:skygame_2d/models/enums.dart';

class Stats {
  final Map<StatType, double> values;
  Stats({
    required double hp,
    required double storage,
    required double atk,
    required double def,
    required double charge,
    required double exe,
  }) : values = {
          StatType.hp: hp,
          StatType.storage: storage,
          StatType.attack: atk,
          StatType.defense: def,
          StatType.charge: charge,
          StatType.execution: exe,
        };

// getter
  double operator [](StatType key) => values[key]!;
}
