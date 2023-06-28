import 'package:bloc/bloc.dart';
import 'package:skygame_2d/bloc/combat/state.dart';
import 'package:skygame_2d/bloc/events.dart';

class CombatBloc extends Bloc<BlocEvent, CombatBlocState> {
  CombatBloc() : super(InitialCombatBlocState());
}
