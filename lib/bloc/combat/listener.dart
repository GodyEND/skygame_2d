import 'package:flame_bloc/flame_bloc.dart';
import 'package:skygame_2d/bloc/combat/bloc.dart';
import 'package:skygame_2d/bloc/combat/state.dart';
import 'package:skygame_2d/bloc/game/bloc.dart';

FlameBlocListener combatBlocListener(GameBloc bloc, CombatBloc combatBloc) {
  return FlameBlocListener<CombatBloc, CombatBlocState>(
    onNewState: (state) {},
    bloc: combatBloc,
  );
}
