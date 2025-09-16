part of employ.widgets;

class EmployStepperFooter extends StatelessWidget {
  final VoidCallback onStepCancel;
  final VoidCallback onStepContinue;
  final Color color;
  final int currentStep;
  final int steps;

  const EmployStepperFooter(
    this.currentStep,
    this.steps,
    this.onStepCancel,
    this.onStepContinue,
    this.color,
  );

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Positioned(
      bottom: mq.padding.bottom,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.0),
        width: mq.size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FooterButton(
              action: onStepCancel,
              icon: EmployIcons.btm_close_dark,
              size: calcSize(mq.size, 60.0),
              theme: Brightness.light,
            ),
            FooterButton(
              action: onStepContinue,
              icon: currentStep == steps - 1
                  ? EmployIcons.btm_send_dark
                  : EmployIcons.btm_next_dark,
              size: calcSize(mq.size, 60.0),
              theme: Brightness.light,
            ),
          ],
        ),
      ),
    );
  }
}
