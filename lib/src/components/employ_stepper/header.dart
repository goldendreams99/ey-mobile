part of employ.widgets;

class EmployStepperHeader extends StatelessWidget {
  final Color color;
  final Color textColor;
  final List<EmployStep> steps;
  final int currentStep;
  final int visibleSteps;
  final Map<int, EmployStepState> states;
  final TabController controller;
  final ValueChanged<int> onStepTapped;
  final Axis direction;

  EmployStepperHeader(
    this.color,
    this.textColor,
    this.steps,
    this.currentStep,
    this.visibleSteps,
    this.states,
    this.controller,
    this.onStepTapped,
    this.direction,
  );

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    for (int i = 0; i < steps.length; i++) {
      children.add(
        Container(
          constraints: BoxConstraints(
            maxHeight: direction == Axis.horizontal ? 50.0 : 65,
            maxWidth: _isLast(i) ? 32.0 : 72.0,
          ),
          child: Flex(
            direction: direction,
            children: <Widget>[
              InkResponse(
                onTap: steps[i].state != EmployStepState.disabled
                    ? () => controller.animateTo(i)
                    : null,
                child: Container(
                  height: direction == Axis.horizontal ? 72.0 : 32,
                  width: 32.0,
                  child: Center(
                    child: _buildCircle(i, false),
                  ),
                ),
              ),
              if (!_isLast(i))
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: direction == Axis.horizontal ? 8.0 : 0,
                      vertical: direction == Axis.vertical ? 8.0 : 0,
                    ),
                    height: 1.0,
                    width: direction == Axis.horizontal ? null : 1.0,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      );
    }
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: direction == Axis.vertical ? 24.0 : 0,
      ),
      child: Center(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: direction,
          child: Flex(
            direction: direction,
            mainAxisAlignment: MainAxisAlignment.center,
            children: children
                .sublist(elementFromView, elementFromView + visibleSteps)
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCircle(int index, bool oldState) {
    final double _kStepSize = 31.0;
    return Container(
      width: _kStepSize,
      height: _kStepSize,
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: kThemeAnimationDuration,
        decoration: BoxDecoration(
          color: _circleColor(index),
          border: Border.all(color: color, width: 2.3),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: _buildCircleChild(index, oldState),
        ),
      ),
    );
  }

  Widget? _buildCircleChild(int index, bool oldState) {
    final EmployStepState? state =
        oldState ? states[index] : steps[index].state;
    assert(state != null);
    switch (state) {
      case EmployStepState.indexed:
      case EmployStepState.disabled:
        return Text(
          '${index + 1}',
          style: _circleText(index),
        );
      case EmployStepState.complete:
        return currentStep == index
            ? Text(
                '${index + 1}',
                style: _circleText(index),
              )
            : Icon(
                Icons.done,
                color: color,
                size: 18.0,
              );
      default:
        return null;
    }
  }

  Color _circleColor(int index) {
    return index == currentStep ? color : Colors.transparent;
  }

  TextStyle _circleText(int index) {
    return FONT.BOLD.merge(TextStyle(
      fontSize: 14.0,
      color: index == currentStep ? textColor : color,
    ));
  }

  int get elementFromView {
    if (currentStep < visibleSteps - 1) return 0;
    if (currentStep + visibleSteps > steps.length)
      return steps.length - visibleSteps;
    return currentStep - (visibleSteps ~/ 2);
  }

  bool _isLast(int index) {
    return elementFromView + visibleSteps - 1 == index;
  }
}
