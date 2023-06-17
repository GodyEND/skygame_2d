import 'package:flutter/services.dart';
import 'package:skygame_2d/game/game.dart';
import 'package:skygame_2d/models/enums.dart';

extension GameInputExt on GameManager {
  bool player1Input(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;

    // P1 options
    // LAce = W
    final isP1LAce = keysPressed.contains(LogicalKeyboardKey.keyW);
    // Lead = D
    final isP1Lead = keysPressed.contains(LogicalKeyboardKey.keyD);
    // RAce = X
    final isP1RAce = keysPressed.contains(LogicalKeyboardKey.keyX);

    if (isKeyDown && isP1LAce) {
      return _validateP1Input(event, keysPressed, BrawlType.leftAce);
    } else if (isKeyDown && isP1Lead) {
      return _validateP1Input(event, keysPressed, BrawlType.lead);
    } else if (isKeyDown && isP1RAce) {
      return _validateP1Input(event, keysPressed, BrawlType.rightAce);
    }
    return false;
  }

  bool player2Input(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;

    // P1 options
    // LAce = ,
    final isP2LAce = keysPressed.contains(LogicalKeyboardKey.comma);
    // Lead = K
    final isP2Lead = keysPressed.contains(LogicalKeyboardKey.keyK);
    // RAce = O
    final isP2RAce = keysPressed.contains(LogicalKeyboardKey.keyO);
    // // Back = A
    // final isP1Back = keysPressed.contains(LogicalKeyboardKey.keyA);

    if (isKeyDown && isP2LAce) {
      return _validateP2Input(event, keysPressed, BrawlType.leftAce);
    } else if (isKeyDown && isP2Lead) {
      return _validateP2Input(event, keysPressed, BrawlType.lead);
    } else if (isKeyDown && isP2RAce) {
      return _validateP2Input(event, keysPressed, BrawlType.rightAce);
    }
    return false;
  }

  _validateP1Input(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed, BrawlType user) {
    // Target Switch A
    final isP1Target = keysPressed.contains(LogicalKeyboardKey.keyA);
    // Swap E
    final isP1Swap = keysPressed.contains(LogicalKeyboardKey.keyE);
    // Retreat R
    final isP1Retreat = keysPressed.contains(LogicalKeyboardKey.keyR);
    // Release F
    final isP1Release = keysPressed.contains(LogicalKeyboardKey.keyF);
    // Guard C
    final isP1Guard = keysPressed.contains(LogicalKeyboardKey.keyC);

    // Auto-Release
    final isP1AutoRelease = keysPressed.contains(LogicalKeyboardKey.keyS);
    final isP1AutoGuard = keysPressed.contains(LogicalKeyboardKey.keyG);
    if (isP1Target) {
      // addToCommandQ(Command(CommandType.target, owner, user));
      return true;
    } else if (isP1Swap) {
      // addToCommandQ(Command(CommandType.swap, owner, user));
      return true;
    } else if (isP1Retreat) {
      // addToCommandQ(Command(CommandType.retreat, owner, user));
      return true;
    } else if (isP1Release) {
      // addToCommandQ(Command(CommandType.releaseAtk, owner, user));
      return true;
    } else if (isP1Guard) {
      // addToCommandQ(Command(CommandType.guard, owner, user));
      return true;
    } else if (isP1AutoRelease) {
      // addToCommandQ(Command(CommandType.autoRelease, owner, user));
      return true;
    } else if (isP1AutoGuard) {
      // addToCommandQ(Command(CommandType.autoRelease, owner, user));
      return true;
    }
    return false;
  }

  _validateP2Input(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed, BrawlType user) {
    // Target Switch :
    final isP2Target = keysPressed.contains(LogicalKeyboardKey.semicolon);
    // Swap I
    final isP2Swap = keysPressed.contains(LogicalKeyboardKey.keyI);
    // Retreat U
    final isP2Retreat = keysPressed.contains(LogicalKeyboardKey.keyU);
    // Release J
    final isP2Release = keysPressed.contains(LogicalKeyboardKey.keyJ);
    // Guard M
    final isP2Guard = keysPressed.contains(LogicalKeyboardKey.keyM);

    // Auto-Release
    final isP2AutoRelease = keysPressed.contains(LogicalKeyboardKey.keyL);
    final isP2AutoGuard = keysPressed.contains(LogicalKeyboardKey.keyH);
    if (isP2Target) {
      // addToCommandQ(Command(CommandType.target, owner, user));
      return true;
    } else if (isP2Swap) {
      // addToCommandQ(Command(CommandType.swap, owner, user));
      return true;
    } else if (isP2Retreat) {
      // addToCommandQ(Command(CommandType.retreat, owner, user));
      return true;
    } else if (isP2Release) {
      // addToCommandQ(Command(CommandType.releaseAtk, owner, user));
      return true;
    } else if (isP2Guard) {
      // addToCommandQ(Command(CommandType.guard, owner, user));
      return true;
    } else if (isP2AutoRelease) {
      // addToCommandQ(Command(CommandType.autoRelease, owner, user));
      return true;
    } else if (isP2AutoGuard) {
      // addToCommandQ(Command(CommandType.autoRelease, owner, user));
      return true;
    }
    return false;
  }
}
