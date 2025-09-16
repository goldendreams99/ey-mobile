import 'package:copy_with_extension/copy_with_extension.dart';

part 'menu_state.g.dart';

@CopyWith()
class MenuState {
  final bool isShown;

  MenuState({
    required this.isShown,
  });
}
