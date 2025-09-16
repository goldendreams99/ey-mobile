part of employ.widgets;

class SignInFormStep2 extends ConsumerWidget {
  final TextEditingController controller;
  final FocusNode node;
  final TextStyle style;
  final Widget decoration;
  final bool visiblePassword;

  const SignInFormStep2(
    this.controller,
    this.node,
    this.style,
    this.decoration,
    this.visiblePassword,
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
            colors: COLOR.gradient['default']!,
            style: FONT.TITLE.merge(
              TextStyle(fontSize: 28.0),
            ),
            textAlign: TextAlign.left,
          ),
          NonBorderTextField(
            height: calcSize(size, 51.0),
            controller: controller,
            margin: EdgeInsets.symmetric(vertical: 10.0),
            color: COLOR.greyish_brown,
            node: node,
            autoFocus: true,
            isPassword: visiblePassword,
            hint: 'Contraseña',
            hintStyle: style.merge(
              TextStyle(
                color: Color.fromRGBO(30, 30, 30, 0.20),
              ),
            ),
            type: TextInputType.emailAddress,
            insidePadding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 9.0),
            style: style,
            suffixDecoration: decoration,
            onChange: (value) =>
                ref.read(signInFormProvider.notifier).setPassword(value),
          ),
        ],
      ),
    );
  }
}
