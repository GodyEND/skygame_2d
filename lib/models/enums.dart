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

enum Owner { p1, p2 }

enum GameState {
  setup,
  combat,
  replace,
  replaceWing,
  replaceSupport,
  replaceReserve,
  end,
}

enum CombatState { attack, release, guard, swap, retreat, fx }

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
  autoRelease
}

enum BrawlType {
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
}

enum MatchPosition {
  p1Lead,
  p1LeftAce,
  p1RightAce,
  p1LeftLink,
  p1RightLink,
  p1Reserve,
  p1Combatant,
  p1HitBox,
  p2Lead,
  p2LeftAce,
  p2RightAce,
  p2LeftLink,
  p2RightLink,
  p2Reserve,
  p2Combatant,
  p2HitBox,
  none,
  defeated,
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
