part of employ.pages;

class Login extends ConsumerStatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final ScrollController controller = ScrollController();
  late bool initialized;

  bool passwordMode = true;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.invalidate(signInFormProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: COLOR.greyish_brown_four_2,
        key: key,
        resizeToAvoidBottomInset: true,
        body: BackToExit(
          child: Container(
            child: SignInForm(
              passwordIsRestarted: false,
              onSignin: signIn,
              passwordIsShown: passwordMode,
              onResetPassword: resetPassword,
              passwordDecoration: InkWell(
                onTap: showPassword,
                child: Icon(
                  passwordMode ? Icons.visibility : Icons.visibility_off,
                  color: COLOR.black_five,
                  size: 20.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showPassword() {
    if (mounted) setState(() => passwordMode = !passwordMode);
  }

  void signIn(String user, String password, bool valid) async {
    try {
      if (!valid) return;
      final config = AppConfig.of(context);
      final auth = EmployProvider.of(context).auth;
      final db = EmployProvider.of(context).database;
      final msg = EmployProvider.of(context).messaging;
      Vibration.vibrate(duration: 100);
      String? resolvedEmail = await Account.getAccountMail(user, config);
      if (resolvedEmail != null) {
        String? id =
            await auth?.signInWithEmailAndPassword(resolvedEmail, password);
        dynamic account = await Account.validAccount(db, id!);
        if (account == null) genericError();
        bool initialized = await ref.read(appProvider.notifier).init(
              db,
              account['company']['id'],
              account['employee']['id'],
            );
        Application.router.pop(context);
        Employee e = Employee.fromJson(account['employee']);
        msg?.subscribe(e);
        if (!e.portal || e.portalPassword) {
          Application.router.navigateTo(
            context,
            Routes.onBording.replaceAll(':screen', 'change'),
            replace: true,
            clearStack: true,
          );
          return;
        }
        if (initialized) {
          if (localStorage.getItem(id) != null) {
            Application.router.navigateTo(
              context,
              Routes.home,
              replace: true,
              clearStack: true,
            );
          } else {
            localStorage.setItem(id, 'true');
            Application.router.navigateTo(
              context,
              Routes.onBording.replaceAll(':screen', 'home'),
              replace: true,
              clearStack: true,
            );
          }
        } else
          genericError();
      } else {
        genericError();
      }
    } catch (e) {
      genericError();
    }
  }

  Future<void> resetPassword(String mail, bool valid) async {
    final auth = EmployProvider.of(context).auth;
    if (!valid) return;
    Vibration.vibrate(duration: 100);
    auth?.forgotPassword(mail);
  }

  void genericError({bool loading = true}) {
    if (loading) Application.router.pop(context);
    Application.showInSnackBar(key, 'Usuario y/o contraseña incorrectos');
  }
}
