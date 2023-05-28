import 'package:skygame_2d/models/enums.dart';

class Costs {
  final Map<CostType, double> values;
  Costs(
    double release,
    double guard,
    double retreat,
    double swap,
  ) : values = {
          CostType.release: release,
          CostType.guard: guard,
          CostType.retreat: retreat,
          CostType.swap: swap,
        };

  double operator [](CostType key) => values[key]!;
}
