part of employ.pages;

class SignPage extends ConsumerStatefulWidget {
  final bool? onlyAgree;
  final bool? canResetPin;
  final bool hasOptions;
  final String? category;

  const SignPage(
      {this.onlyAgree,
      this.canResetPin,
      this.hasOptions = true,
      this.category});

  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends ConsumerState<SignPage>
    with TickerProviderStateMixin {
  TabController? controller;
  dynamic payload = {};

  @override
  void initState() {
    super.initState();
    payload['document_status'] = 3;
    payload['signer_observation'] = null;
    controller = TabController(vsync: this, length: 3);
    controller?.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final manager = ref.watch(appProvider);
    final bool isKeyboardShown =
        MediaQuery.of(context).viewInsets.bottom == 0.0;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: STYLES.vGradient(theme: manager.settings!.theme),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: controller,
                      children: <Widget>[
                        SignPinPage(
                          controller: controller,
                          hasOptions: widget.hasOptions,
                          canResetPin: widget.canResetPin!,
                          onlyAgree: widget.onlyAgree!,
                          process: (pin) => onChange('pin', pin),
                          onReset: resetPin,
                        ),
                        SignConfigPage(
                          agreed: payload['document_status'] != null &&
                              payload['document_status'] == 4,
                          observation: payload['signer_observation'],
                          onChanged: onChange,
                        ),
                        SignResetPinPage(),
                      ],
                    ),
                  )
                ],
              ),
              isKeyboardShown
                  ? Positioned(
                      bottom: padding.bottom,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.0),
                        width: size.width,
                        child: Row(
                          mainAxisAlignment: controller?.index == 1
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FooterButton(
                              action: controller?.index != 0
                                  ? backToPinPage
                                  : close,
                              icon: controller?.index == 1
                                  ? EmployIcons.btm_check_dark
                                  : EmployIcons.btm_close_dark,
                              size: calcSize(size, 60.0),
                              theme: Brightness.light,
                            ),
                            controller?.index != 1
                                ? FooterButton(
                                    action: sendPin,
                                    icon: EmployIcons.btm_next_dark,
                                    size: calcSize(size, 60.0),
                                    theme: Brightness.light,
                                    enabled: canConfirm,
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  void close() {
    Application.router.pop(context);
  }

  void backToPinPage() {
    if (payload['document_status'] == 4 &&
        (payload['signer_observation'] == null ||
            payload['signer_observation'].toString().isEmpty)) {
      Fluttertoast.showToast(
        msg: 'Ingresá un comentario',
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }
    controller?.animateTo(0);
  }

  void onChange(String target, dynamic value) {
    payload[target] = value;
    setState(() {});
  }

  void sendPin() {
    if (!canConfirm) return;
    if (controller?.index == 0) {
      if (payload['pin'] == null || payload['pin'].length < 4) return;
      Navigator.of(context).pop(payload);
    } else if (controller?.index == 2) resetPin();
  }

  void resetPin() async {
    final manager = ref.read(appProvider);
    final provider = EmployProvider.of(context);
    final config = AppConfig.of(context);
    String? module = widget.category == null
        ? manager.employee!.moduleLicenseSign
        : widget.category == 'Paycheck'
            ? manager.employee!.modulePaycheckSign
            : manager.employee!.moduleDocumentSign;
    if (module == 'pki') {
      ref.read(appProvider.notifier).pinReset(config);
    } else if (module == 'bio') {
      String ref =
          'client/${manager.company!.id}/employee/${manager.employee!.id}/signplify';
      await provider.database.remove(ref);
    }
    provider.messaging?.unsubscribe(manager.employee);
    provider.auth?.signOut();
    Application.router.navigateTo(
      context,
      Routes.login,
      replace: true,
      clearStack: true,
    );
  }

  bool get canConfirm {
    return (controller?.index != 2 &&
            payload['pin'] != null &&
            payload['pin'].length >= 4) ||
        controller?.index == 2;
  }
}
