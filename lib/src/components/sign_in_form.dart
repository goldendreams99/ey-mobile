part of employ.widgets;

class SignInForm extends ConsumerStatefulWidget {
  final bool passwordIsRestarted;
  final bool passwordIsShown;
  final Function(String, String, bool) onSignin;
  final Function(String, bool) onResetPassword;
  final Widget passwordDecoration;

  const SignInForm({
    required this.passwordIsRestarted,
    required this.onSignin,
    required this.onResetPassword,
    required this.passwordDecoration,
    required this.passwordIsShown,
  });

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final FocusNode uNode = FocusNode();
  final FocusNode pNode = FocusNode();
  final FocusNode mNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, initialIndex: 0, length: 3);
    controller?.addListener(() {
      if (mounted) setState(() {});
    });
    userController.addListener(() {
      if (mounted) setState(() {});
    });
    passwordController.addListener(() {
      if (mounted) setState(() {});
    });
    mailController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    userController.dispose();
    passwordController.dispose();
    mailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    EdgeInsets padding = MediaQuery.of(context).padding;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(32.0, padding.top + 25.0, 32.0, 0.0),
          color: Colors.white,
          child: TabBarView(
            controller: controller,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              SignInFormStep1(userController, uNode, textStyle, continueSignin),
              SignInFormStep2(
                passwordController,
                pNode,
                textStyle,
                widget.passwordDecoration,
                widget.passwordIsShown,
              ),
              SignInFormStep3(textStyle, mailController, mNode),
            ],
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              controller?.index != 2
                  ? Container(
                      margin: EdgeInsets.only(bottom: 10.0, left: 17.0),
                      child: FlatButton(
                        onPressed: () {
                          uNode.unfocus();
                          pNode.unfocus();
                          controller?.animateTo(2);
                        },
                        child: Text(
                          "Recuperar contraseña",
                          style: FONT.TITLE.merge(
                            TextStyle(
                              color: COLOR.greyish_brown_four,
                              fontSize: 14.5,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Container(
                color: COLOR.greyish_brown_four_2,
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                width: size.width,
                height: 92.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    controller?.index != 0
                        ? FooterButton(
                            action: () {
                              if (controller?.index == 1) pNode.unfocus();
                              if (controller?.index == 2) mNode.unfocus();
                              controller?.animateTo(0);
                            },
                            icon: controller?.index == 2
                                ? EmployIcons.btm_close_dark
                                : EmployIcons.btm_back_dark,
                            size: 60.0,
                            theme: Brightness.light,
                          )
                        : Container(),
                    FooterButton(
                      enabled: validateNexStep,
                      action: continueSignin,
                      icon: controller?.index == 0
                          ? EmployIcons.btm_next_dark
                          : EmployIcons.btm_check_dark,
                      size: 60.0,
                      theme: Brightness.light,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void navigate(int index) {
    controller?.animateTo(index);
  }

  void resetPassword() async {
    SignInFormState manager = ref.read(signInFormProvider);
    await widget.onResetPassword(manager.email, manager.canForgot);
    navigate(2);
  }

  void login() {
    final size = MediaQuery.of(context).size;
    SignInFormState manager = ref.read(signInFormProvider);
    Navigator.push(
      context,
      FadeRoute(
        widget: WillPopScope(
          onWillPop: () async => false,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: Container(
              color: COLOR.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LottieAnim(
                    duration: Duration(milliseconds: 500),
                    path: 'assets/animation/dot_animation.json',
                    size: Size(size.width / 2, size.width / 2),
                    itRepeatable: true,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
    widget.onSignin(manager.user, manager.password, manager.valid);
  }

  void backToSignin() {
    Vibration.vibrate(duration: 100);
    mNode.unfocus();
    navigate(0);
  }

  void forgotPassword() async {
    final provider = EmployProvider.of(context);
    Vibration.vibrate(duration: 100);
    try {
      await provider.auth?.forgotPassword(mailController.text);
    } catch (e) {
      print(e);
    }
    Application.router.navigateTo(
      context,
      Routes.onBording.replaceAll(':screen', 'reset'),
      replace: true,
      clearStack: true,
    );
  }

  TextStyle get textStyle => FONT.TITLE.merge(
        TextStyle(color: COLOR.greyish_brown, fontSize: 23.0),
      );

  bool get validateNexStep {
    final manager = ref.read(signInFormProvider);
    if (controller?.index == 0) return manager.validUser;
    if (controller?.index == 1) return manager.valid;
    if (controller?.index == 2) return manager.canForgot;
    return false;
  }

  void continueSignin() {
    if (!validateNexStep) return;
    if (controller?.index == 0) {
      uNode.unfocus();
      controller?.animateTo(1);
      return;
    }
    if (controller?.index == 1) {
      pNode.unfocus();
      login();
      return;
    }
    if (controller?.index == 2) {
      mNode.unfocus();
      forgotPassword();
      return;
    }
  }
}
