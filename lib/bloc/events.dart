abstract class BlocEvent {}

abstract class CombatBlocEvent extends BlocEvent {}

class EmptyEvent extends BlocEvent {}

class PlayerTeamReadyEvent extends BlocEvent {}

class CombatTurnEnd extends CombatBlocEvent {}
