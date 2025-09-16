part of employ.widgets;

class SignInFormStep1 extends ConsumerWidget {
  final TextEditingController userController;
  final FocusNode userNode;
  final TextStyle textStyle;
  final Function onNext;

  const SignInFormStep1(
    this.userController,
    this.userNode,
    this.textStyle,
    this.onNext,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GradientText(
            '''¡Hola!''',
            colors: COLOR.gradient['pink']!,
            style: FONT.TITLE.merge(
              TextStyle(fontSize: 30.0),
            ),
            textAlign: TextAlign.left,
          ),
          NonBorderTextField(
            height: calcSize(size, 51.0),
            action: TextInputAction.next,
            controller: userController,
            margin: EdgeInsets.symmetric(vertical: 10.0),
            color: COLOR.greyish_brown,
            node: userNode,
            autoFocus: true,
            hint: 'Ingresa tu usuario',
            hintStyle: textStyle.merge(
              TextStyle(
                color: Color.fromRGBO(30, 30, 30, 0.20),
              ),
            ),
            type: TextInputType.emailAddress,
            insidePadding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 9.0),
            style: textStyle,
            onChange: (value) =>
                ref.read(signInFormProvider.notifier).setUser(value),
            onSubmit: (e) => onNext(),
          ),
        ],
      ),
    );
  }
}
