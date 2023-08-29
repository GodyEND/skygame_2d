import 'package:flutter/services.dart';
import 'package:skygame_2d/bloc/key_input/bloc.dart';
import 'package:skygame_2d/main.dart';
import 'package:skygame_2d/utils.dart/enums.dart';
import 'package:skygame_2d/utils.dart/constants.dart';

var inputKeys = {
  Constants.FIRST_PLAYER: [
    // Player 1
    LogicalKeyboardKey.keyW, // Up
    LogicalKeyboardKey.keyS, // Down
    LogicalKeyboardKey.keyA, // Left
    LogicalKeyboardKey.keyD, // Right
    LogicalKeyboardKey.space, // Confirm
    LogicalKeyboardKey.keyC, // Cancel
    LogicalKeyboardKey.keyX, // Remove
    LogicalKeyboardKey.exclamation, // Save
  ],
  Constants.SECOND_PLAYER: [
    // Player 2
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.arrowRight,
    LogicalKeyboardKey.enter, // Confirm
    LogicalKeyboardKey.backspace, // Cancel
    LogicalKeyboardKey.delete, // Remove
    LogicalKeyboardKey.numpad1, // Save
  ],
};

extension KeyInputExt on SkyGame2D {
  bool menuInput(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
    int ownerID,
  ) {
    final isKeyDown = event is RawKeyDownEvent;

    final isUp = keysPressed.contains(inputKeys[ownerID]![0]);
    final isDown = keysPressed.contains(inputKeys[ownerID]![1]);
    final isLeft = keysPressed.contains(inputKeys[ownerID]![2]);
    final isRight = keysPressed.contains(inputKeys[ownerID]![3]);
    final isConfirm = keysPressed.contains(inputKeys[ownerID]![4]);
    final isCancel = keysPressed.contains(inputKeys[ownerID]![5]);
    final isRemove = keysPressed.contains(inputKeys[ownerID]![6]);
    final isSave = keysPressed.contains(inputKeys[ownerID]![7]);
    final keyBloc = playerBlocs
        .firstWhere((e) => e.state.player.ownerID == ownerID)
        .state
        .keyBloc;
    if (isKeyDown && isUp) {
      keyBloc.add(KeyInputUpEvent(ownerID));
      return true;
    } else if (isKeyDown && isDown) {
      keyBloc.add(KeyInputDownEvent(ownerID));
      return true;
    } else if (isKeyDown && isLeft) {
      keyBloc.add(KeyInputLeftEvent(ownerID));
      return true;
    } else if (isKeyDown && isRight) {
      keyBloc.add(KeyInputRightEvent(ownerID));
      return true;
    } else if (isKeyDown && isConfirm) {
      keyBloc.add(KeyInputConfirmEvent(ownerID));
      return true;
    } else if (isKeyDown && isCancel) {
      keyBloc.add(KeyInputCancelEvent(ownerID));
      return true;
    } else if (isKeyDown && isRemove) {
      keyBloc.add(KeyInputRemoveEvent(ownerID));
      return true;
    } else if (isKeyDown && isSave) {
      keyBloc.add(KeyInputSaveEvent(ownerID));
      return true;
    }
    return false;
  }

  bool player1CombatInput(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;

    // P1 options
    // LAce = W
    final isP1LAce = keysPressed.contains(LogicalKeyboardKey.keyW);
    // Lead = D
    final isP1Lead = keysPressed.contains(LogicalKeyboardKey.keyD);
    // RAce = X
    final isP1RAce = keysPressed.contains(LogicalKeyboardKey.keyX);

    if (isKeyDown && isP1LAce) {
      return _validateP1Input(event, keysPressed, MatchPosition.leftAce);
    } else if (isKeyDown && isP1Lead) {
      return _validateP1Input(event, keysPressed, MatchPosition.lead);
    } else if (isKeyDown && isP1RAce) {
      return _validateP1Input(event, keysPressed, MatchPosition.rightAce);
    }
    return false;
  }

  bool player2CombatInput(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
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
      return _validateP2Input(event, keysPressed, MatchPosition.leftAce);
    } else if (isKeyDown && isP2Lead) {
      return _validateP2Input(event, keysPressed, MatchPosition.lead);
    } else if (isKeyDown && isP2RAce) {
      return _validateP2Input(event, keysPressed, MatchPosition.rightAce);
    }
    return false;
  }

  _validateP1Input(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed,
      MatchPosition user) {
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

  _validateP2Input(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed,
      MatchPosition user) {
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
