part of employ.widgets;

class SignInFormStep3 extends ConsumerWidget {
  final TextStyle textStyle;
  final TextEditingController controller;
  final FocusNode node;

  const SignInFormStep3(this.textStyle, this.controller, this.node);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GradientText(
            '''Recuperar\ncontraseña''',
            colors: COLOR.gradient['pink']!,
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
            autoFocus: true,
            node: node,
            hint: 'Ingresa tu mail',
            hintStyle: textStyle.merge(
              TextStyle(
                color: Color.fromRGBO(30, 30, 30, 0.20),
              ),
            ),
            type: TextInputType.emailAddress,
            insidePadding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 9.0),
            style: textStyle,
            onChange: (value) =>
                ref.read(signInFormProvider.notifier).setEmail(value),
          ),
        ],
      ),
    );
  }
}
