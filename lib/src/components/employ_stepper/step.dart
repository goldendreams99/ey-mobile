part of employ.widgets;

enum EmployStepState {
  indexed,
  complete,
  disabled,
}

class EmployStep {
  final Widget content;
  final EmployStepState state;
  final bool isActive;

  const EmployStep({
    required this.content,
    this.state = EmployStepState.indexed,
    this.isActive = false,
  });
}
