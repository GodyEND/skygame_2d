import 'package:skygame_2d/graphics/graphics.dart';
import 'package:skygame_2d/models/bes.dart';
import 'package:skygame_2d/models/costs.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/models/fx.dart';
import 'package:skygame_2d/models/match_unit/unit.dart';
import 'package:skygame_2d/models/release.dart';
import 'package:skygame_2d/models/stats.dart';
import 'package:skygame_2d/setup.dart';

class Angelos1 extends Unit {
  Angelos1()
      : super(
          name: 'Flame Redwing',
          element: Element.red,
          species: Species.angelos,
          image: Sprites.q('angelos_1$PF_SPRITE'),
          profile: Sprites.q('angelos_1$PF_PROFILE'),
          select: Sprites.q('angelos_1$PF_SELECT'),
          stats:
              Stats(hp: 40, storage: 80, atk: 70, def: 40, charge: 60, exe: 80),
          release: Releases.q('Flame Lance'),
          fx: FXs.q('Body of Water'),
          bes: BES(100, 50, 40, 25, 25, 0, 75, 0, 0),
          costs: Costs(0, 0, 0, 0),
        );
}

class Angelos2 extends Unit {
  Angelos2()
      : super(
          name: 'Eron Greenwing',
          element: Element.brown,
          species: Species.angelos,
          image: Sprites.q('angelos_2$PF_SPRITE'),
          profile: Sprites.q('angelos_2$PF_PROFILE'),
          select: Sprites.q('angelos_2$PF_SELECT'),
          stats:
              Stats(hp: 80, storage: 60, atk: 40, def: 60, charge: 60, exe: 40),
          release: Releases.q('Earth Coat'),
          fx: FXs.q('Chaos Zone'),
          bes: BES(100, 25, 20, 25, 75, 0, 75, 50, 20),
          costs: Costs(0, 0, 0, 0),
        );
}

class Angelos3 extends Unit {
  Angelos3()
      : super(
          name: 'Icarus Greenwing',
          element: Element.green,
          species: Species.angelos,
          image: Sprites.q('angelos_3$PF_SPRITE'),
          profile: Sprites.q('angelos_3$PF_PROFILE'),
          select: Sprites.q('angelos_3$PF_SELECT'),
          stats: Stats(
              hp: 60, storage: 100, atk: 60, def: 40, charge: 100, exe: 90),
          release: Releases.q('Low Swipe'),
          fx: FXs.q('Pressure'),
          bes: BES(100, 25, 50, 25, 0, 0, 25, 25, 0),
          costs: Costs(0, 0, 0, 0),
        );
}

class Angelos4 extends Unit {
  Angelos4()
      : super(
          name: 'Josephine Wellwing',
          element: Element.purple,
          species: Species.angelos,
          image: Sprites.q('angelos_4$PF_SPRITE'),
          profile: Sprites.q('angelos_4$PF_PROFILE'),
          select: Sprites.q('angelos_4$PF_SELECT'),
          stats: Stats(
              hp: 60, storage: 100, atk: 40, def: 60, charge: 80, exe: 60),
          release: Releases.q('Dragon Twister'),
          fx: FXs.q('Secure'),
          bes: BES(100, 25, 50, 25, 0, 0, 50, 25, 0),
          costs: Costs(0, 0, 0, 0),
        );
}

class Angelos5 extends Unit {
  Angelos5()
      : super(
          name: 'Denis Stormwing',
          element: Element.yellow,
          species: Species.angelos,
          image: Sprites.q('angelos_5$PF_SPRITE'),
          profile: Sprites.q('angelos_5$PF_PROFILE'),
          select: Sprites.q('angelos_5$PF_SELECT'),
          stats:
              Stats(hp: 60, storage: 50, atk: 40, def: 60, charge: 80, exe: 60),
          release: Releases.q('Magnetise'),
          fx: FXs.q('Motorise'),
          bes: BES(150, 50, 40, 50, 0, 30, 25, 0, 0),
          costs: Costs(0, 0, 0, 0),
        );
}
