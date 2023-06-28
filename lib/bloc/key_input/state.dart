import 'package:equatable/equatable.dart';

class PlayerKeyInputBlocState extends Equatable {
  final int rowIndex;
  final int colIndex;
  final int rowLength;
  final int options;
  const PlayerKeyInputBlocState({
    required this.rowIndex,
    required this.colIndex,
    required this.rowLength,
    required this.options,
  });
  PlayerKeyInputBlocState copyWith({
    int? cRowIndex,
    int? cColIndex,
    int? cRowLength,
    int? cOptions,
  }) {
    return PlayerKeyInputBlocState(
      rowIndex: cRowIndex ?? rowIndex,
      colIndex: cColIndex ?? colIndex,
      rowLength: cRowLength ?? rowLength,
      options: cOptions ?? options,
    );
  }

  @override
  List<Object?> get props => [rowIndex, colIndex, rowLength, options];
}

class InitialPlayerKeyInputBlocState extends PlayerKeyInputBlocState {
  const InitialPlayerKeyInputBlocState({
    required int rowLength,
    required int options,
  }) : super(
          rowIndex: 0,
          colIndex: 0,
          rowLength: rowLength,
          options: options,
        );
}

class KeyInputBlocState extends Equatable {
  final List<PlayerKeyInputBlocState> playerInputStates;

  const KeyInputBlocState({
    required this.playerInputStates,
  });

  KeyInputBlocState copyWith({
    List<PlayerKeyInputBlocState>? cPlayerInputStates,
  }) {
    return KeyInputBlocState(
      playerInputStates: cPlayerInputStates ?? playerInputStates,
    );
  }

  @override
  List<Object?> get props => [playerInputStates];
}

class InitialKeyInputBlocState extends KeyInputBlocState {
  const InitialKeyInputBlocState(
      List<PlayerKeyInputBlocState> playerInputStates)
      : super(playerInputStates: playerInputStates);
}
