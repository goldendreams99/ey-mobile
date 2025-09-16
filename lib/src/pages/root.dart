part of employ.pages;

class Root extends ConsumerStatefulWidget {
  Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends ConsumerState<Root> with TickerProviderStateMixin {
  bool procesing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = EmployProvider.of(context);
      provider.messaging?.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = EmployProvider.of(context);
    return Scaffold(
      backgroundColor: COLOR.white,
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            LottieAnim(
              duration: Duration(milliseconds: 1500),
              path: 'assets/animation/employ-intro.json',
              size: Size(160.0, 160.0),
              itRepeatable: false,
              callback: () {
                provider.messaging?.grantedPermission(context).then((_) {
                  resolveScreens();
                });
              },
            )
          ],
        ),
      ),
    );
  }

  void resolveScreens() async {
    final EmployProvider provider = EmployProvider.of(context);
    final Authentication? auth = provider.auth;
    try {
      if (!procesing) {
        procesing = true;
        String? currentUser = await auth?.currentId();
        if (currentUser != null) {
          dynamic account =
              await Account.validAccount(provider.database, currentUser);
          if (account == null)
            navigateTo(Routes.login);
          else {
            bool initialized = await ref.read(appProvider.notifier).init(
                  provider.database,
                  account['company']['id'],
                  account['employee']['id'],
                );
            Employee e = Employee.fromJson(account['employee']);
            provider.messaging?.subscribe(e);
            if (!e.portal) {
              Application.router.navigateTo(
                context,
                Routes.onBording.replaceAll(':screen', 'change'),
                replace: true,
                clearStack: true,
              );
              return;
            }
            if (initialized)
              navigateTo(Routes.home);
            else
              navigateTo(Routes.login);
          }
        } else {
          navigateTo(Routes.login);
        }
      }
    } catch (e) {
      if (auth != null) auth.signOut();
      navigateTo(Routes.login);
    }
  }

  void navigateTo(String route) {
    Application.router.navigateTo(
      context,
      route,
      replace: true,
      transition: fluro.TransitionType.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
      clearStack: true,
    );
  }
}
