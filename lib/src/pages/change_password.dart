part of employ.pages;

class ChangePassword extends ConsumerStatefulWidget {
  final String? company;
  final String? employee;

  const ChangePassword({this.company, this.employee});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends ConsumerState<ChangePassword> {
  final TextEditingController password = TextEditingController();
  final TextEditingController cpassword = TextEditingController();
  final FocusNode pNode = FocusNode();
  final FocusNode cpNode = FocusNode();
  bool obscure = true;
  bool visible = true;

  @override
  void initState() {
    super.initState();
    password.addListener(() {
      setState(() {});
    });
    cpassword.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    password.dispose();
    cpassword.dispose();
    super.dispose();
  }

  TextStyle get style => FONT.TITLE.merge(
        TextStyle(color: COLOR.greyish_brown, fontSize: 23.0),
      );

  bool get canChange {
    return password.text.isNotEmpty &&
        password.text.length >= 6 &&
        cpassword.text == password.text;
  }

  void change() async {
    pNode.unfocus();
    cpNode.unfocus();
    if (!canChange) return;
    final manager = ref.read(appProvider);
    final provider = EmployProvider.of(context);
    await provider.auth?.changePassword(password.text);
    await provider.database.remove(
        'client/${manager.company!.id}/employee/${manager.employee!.id}/portal_password');
    await provider.database.update(
        'client/${manager.company!.id}/employee/${manager.employee!.id}',
        {'portal': true});
    Application.router.navigateTo(
      context,
      Routes.home,
      replace: true,
      clearStack: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: COLOR.greyish_brown_four_2,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              color: COLOR.white,
              padding: EdgeInsets.only(
                  top: padding.top + 20.0, left: 32.0, right: 32.0),
              child: Column(
                children: <Widget>[
                  NonBorderTextField(
                    height: calcSize(size, 51.0),
                    controller: password,
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    color: COLOR.greyish_brown,
                    node: pNode,
                    autoFocus: true,
                    isPassword: obscure,
                    hint: 'Contraseña',
                    hintStyle: style.merge(
                      TextStyle(
                        color: Color.fromRGBO(30, 30, 30, 0.20),
                      ),
                    ),
                    type: TextInputType.emailAddress,
                    insidePadding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 9.0),
                    style: style,
                    onSubmit: (e) {
                      pNode.unfocus();
                      FocusScope.of(context).requestFocus(cpNode);
                    },
                    suffixDecoration: IconButton(
                      color: COLOR.black,
                      icon: Icon(
                        obscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        obscure = !obscure;
                        setState(() {});
                      },
                    ),
                  ),
                  NonBorderTextField(
                    height: calcSize(size, 51.0),
                    controller: cpassword,
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    color: COLOR.greyish_brown,
                    node: cpNode,
                    autoFocus: false,
                    isPassword: visible,
                    hint: 'Repetir Contraseña',
                    hintStyle: style.merge(
                      TextStyle(
                        color: Color.fromRGBO(30, 30, 30, 0.20),
                      ),
                    ),
                    type: TextInputType.emailAddress,
                    insidePadding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 9.0),
                    style: style,
                    onSubmit: (e) {
                      cpNode.unfocus();
                      change();
                    },
                    suffixDecoration: IconButton(
                      color: COLOR.black,
                      icon: Icon(
                        visible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        visible = !visible;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: padding.bottom,
              left: 0.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    color: COLOR.greyish_brown_four_2,
                    padding: EdgeInsets.symmetric(horizontal: 3.0),
                    width: size.width,
                    height: 92.0,
                    alignment: Alignment.centerRight,
                    child: FooterButton(
                      action: change,
                      icon: EmployIcons.btm_check_dark,
                      size: calcSize(size, 60.0),
                      theme: Brightness.light,
                      enabled: canChange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
