import 'package:skygame_2d/abilities/event.dart';
import 'package:skygame_2d/game/helper.dart';
import 'package:skygame_2d/game/unit.dart';
import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/game/trackers.dart';
import 'package:skygame_2d/models/enums.dart';
import 'package:skygame_2d/models/release.dart';
import 'package:skygame_2d/utils.dart/extensions.dart';

class Release1 extends Release {
  Release1()
      : super(
          'Flame Lance',
          text: 'Inflict Burn for 2 turns.',
          type: ReleaseType.pierce,
        );

  @override
  void action(MatchUnit user, GameManager game) async {
    final targetLocations = [user.target];
    targetLocations.addAll(MatchHelper.getLinkRef(
        game.field[user.target]!.ownerID,
        MatchHelper.getBrawlType(user.target)));

    for (var targetLocation in targetLocations) {
      final target = game.field[targetLocation];
      if (target == null) continue;

      // TODO: if user attack hit
      // TODO: decide if burn event triggers once/multiple times per turn
      final existingEvent =
          target.eventQ.firstWhereOrNull((e) => e.event is Burn);
      if (existingEvent != null) {
        existingEvent.turn += 2;
      } else {
        target.eventQ.add(EventNotation(Burn(), target.id, 2));
      }
    }
  }
}

class Release2 extends Release {
  Release2()
      : super(
          'Earth Coat',
          text: 'Increase Offense & Defense damage by 30%',
          type: ReleaseType.base,
        );

  @override
  void action(MatchUnit user, GameManager game) {
    user.current.stats.values[StatType.attack] =
        user.current.stats[StatType.attack] * 1.3;
    user.current.stats.values[StatType.defense] =
        user.current.stats[StatType.defense] * 1.3;
  }
}

class Release3 extends Release {
  Release3()
      : super(
          'Low Swipe',
          text: '.',
          type: ReleaseType.pursuit,
        );

  @override
  void action(MatchUnit user, GameManager game) {}
}

class Release4 extends Release {
  Release4()
      : super(
          'Dragon Twister',
          text: '',
          type: ReleaseType.base,
        );

  @override
  void action(MatchUnit user, GameManager game) {}
}

class Release5 extends Release {
  Release5()
      : super(
          'Magnetise',
          text: '.',
          type: ReleaseType.launcher,
        );

  @override
  void action(MatchUnit user, GameManager game) {}
}
