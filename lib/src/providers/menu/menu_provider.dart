import 'package:employ/src/providers/menu/menu_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuNotifier extends StateNotifier<MenuState> {
  MenuNotifier()
      : super(MenuState(
          isShown: false,
        ));

  setIsShown(bool newValue) {
    state = state.copyWith(isShown: newValue);
  }
}

final menuProvider = StateNotifierProvider<MenuNotifier, MenuState>(
  (ref) => MenuNotifier(),
);
