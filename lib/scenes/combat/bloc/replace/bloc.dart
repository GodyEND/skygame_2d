import 'package:bloc/bloc.dart';
import 'package:skygame_2d/bloc/events.dart';
import 'package:skygame_2d/scenes/combat/bloc/replace/state.dart';

class ReplaceBloc extends Bloc<BlocEvent, ReplaceBlocState> {
  ReplaceBloc({required ReplaceBlocState initialState}) : super(initialState) {}
}
