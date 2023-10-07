enum Element { red, green, blue, brown, yellow, purple, white, black, grey }

enum Species { angelos, huecos, anara, palajinn, supra }

enum ReleaseType { base, wide, pierce, launcher, pursuit }

enum FXType { soul, link, entry, retreat, aura, limit, finale }

enum StatType { hp, storage, attack, defense, charge, execution }

enum BESType {
  hit,
  evasion,
  counter,
  crit,
  critResist,
  lethality,
  block,
  force,
  blockMastery
}

enum CostType { release, retreat, guard, swap }

enum SceneState {
  load,
  teamBuilder, // Players select units
  teamFormation,
  combat, // run simulation
  end,
}

enum CombatState { attack, release, guard, swap, retreat, fx, replace, none }

enum PlayerState { waiting, replace, ready }

enum MatchState { setup, base, replace, end }

enum CommandType {
  normalAtk,
  guard,
  retreat,
  swap,
  releaseAtk,
  target,
  autoGuard,
  autoRelease,
}

enum MatchPosition {
  lead,
  leftAce,
  rightAce,
  leftLink,
  rightLink,
  reserve1,
  reserve2,
  reserve3,
  reserve4,
  reserve5,
  defeated,
  replaceable,
  none,
}

enum CombatPosition {
  hitbox,
  challenger,
}

enum CombatEventResult {
  hit,
  dodge,
  counter,
  crit,
  lethal,
  block,
  overwhelm,
  stagger,
  none,
}

enum TeamBuilderViewState {
  load,
  team,
  builder,
  characterSelect,
  teamName,
  wait,
}

enum TeamFormationViewState {
  load,
  formation,
  characterSelect,
  wait,
}
