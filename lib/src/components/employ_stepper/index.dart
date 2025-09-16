part of employ.widgets;

class EmployStepper extends StatefulWidget {
  final int? visibleSteps;
  final List<EmployStep> steps;
  final ScrollPhysics? physics;
  final int currentStep;
  final Color color;
  final Color textColor;
  final String? title;
  final bool swipeable;
  final ValueChanged<int>? onStepTapped;
  final VoidCallback? onStepContinue;
  final VoidCallback? onStepCancel;
  final ValueChanged<int>? onStepSwipe;
  final bool showActions;
  final double spacing;
  final Axis direction;

  const EmployStepper({
    this.title,
    required this.steps,
    this.physics,
    this.currentStep = 0,
    this.color = Colors.white,
    this.textColor = Colors.blue,
    this.onStepCancel,
    this.onStepSwipe,
    this.onStepContinue,
    this.onStepTapped,
    this.swipeable = true,
    this.showActions = true,
    this.spacing = 30.0,
    this.direction = Axis.horizontal,
    this.visibleSteps,
  });

  @override
  _EmployStepperState createState() => _EmployStepperState();
}

class _EmployStepperState extends State<EmployStepper>
    with TickerProviderStateMixin {
  final Map<int, EmployStepState> _oldStates = <int, EmployStepState>{};
  late TabController controller;
  int visibleSteps = 0;

  @override
  void initState() {
    for (int i = 0; i < widget.steps.length; i += 1) {
      _oldStates[i] = widget.steps[i].state;
    }
    controller = TabController(
      vsync: this,
      initialIndex: widget.currentStep,
      length: widget.steps.length,
    );
    controller.addListener(() {
      if (widget.onStepTapped != null) {
        widget.onStepTapped!(controller.index);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EmployStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.steps.length == oldWidget.steps.length);
    for (int i = 0; i < oldWidget.steps.length; i += 1)
      _oldStates[i] = oldWidget.steps[i].state;
    if (oldWidget.currentStep != widget.currentStep)
      Timer(Duration(milliseconds: 200), () {
        controller.animateTo(widget.currentStep);
      });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (widget.visibleSteps != null) {
      visibleSteps = widget.visibleSteps! > widget.steps.length
          ? widget.steps.length
          : widget.visibleSteps!;
    } else if (widget.direction == Axis.horizontal) {
      visibleSteps = widget.steps.length > 5 ? 5 : widget.steps.length;
    } else {
      visibleSteps = widget.steps.length;
    }
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.topLeft,
      children: <Widget>[
        Column(
          children: <Widget>[
            /// [Title]
            if (widget.title != null)
              Container(
                height: calcSize(size, 96.0),
                width: size.width,
                padding: EdgeInsets.fromLTRB(22.0, 0, 16.0, 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.title ?? '',
                          style: FONT.TITLE.merge(
                            TextStyle(
                                fontSize: 30.0,
                                color: widget.color.withOpacity(0.3)),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            /// [header]
            Expanded(
              child: Flex(
                direction: widget.direction == Axis.vertical
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  EmployStepperHeader(
                    widget.color,
                    widget.textColor,
                    widget.steps,
                    widget.currentStep,
                    visibleSteps,
                    _oldStates,
                    controller,
                    widget.onStepTapped ?? (value) => {},
                    widget.direction,
                  ),

                  /// [Content]
                  Expanded(
                    child: EmployTabBarView(
                      direction: widget.direction,
                      physics: widget.swipeable
                          ? null
                          : NeverScrollableScrollPhysics(),
                      controller: controller,
                      children: <Widget>[]..addAll(
                          widget.steps.map((step) {
                            return Container(
                              padding: EdgeInsets.only(top: widget.spacing),
                              child: step.content,
                            );
                          }).toList(),
                        ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        /// [Controls]
        widget.showActions
            ? EmployStepperFooter(
                widget.currentStep,
                widget.steps.length,
                widget.onStepCancel ?? () => {},
                tapContinue,
                widget.color,
              )
            : Container(),
      ],
    );
  }

  void tapContinue() {
    widget.onStepContinue?.call();
    if ((widget.currentStep) <= (widget.steps.length - 2))
      controller.animateTo((widget.currentStep) + 1);
  }
}
