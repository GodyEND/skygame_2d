import 'package:skygame_2d/models/enums.dart';

class BES {
  final Map<BESType, double> values;
  BES(double hit, double eva, double cnt, double crt, double cres, double leth,
      double block, double knb, double bm)
      : values = {
          BESType.hit: hit,
          BESType.evasion: eva,
          BESType.counter: cnt,
          BESType.crit: crt,
          BESType.critResist: cres,
          BESType.lethality: leth,
          BESType.block: block,
          BESType.force: knb,
          BESType.blockMastery: bm,
        };

  // getter
  double operator [](BESType key) => values[key]!;
}
