part of employ.pages;

class ProfilePhonePageBack {
  String code;
  String phone;

  ProfilePhonePageBack({
    required this.code,
    required this.phone,
  });
}

class ProfilePhonePage extends ConsumerStatefulWidget {
  final String? phone;

  const ProfilePhonePage({this.phone});

  @override
  ProfilePhonePageState createState() => ProfilePhonePageState();
}

class ProfilePhonePageState extends ConsumerState<ProfilePhonePage> {
  late TextEditingController phoneController;
  final node = FocusNode();
  String? code;

  @override
  void initState() {
    phoneController = TextEditingController(text: widget.phone ?? '');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final employee = ref.read(appProvider).employee;
      code = employee!.book.timeZone;
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final settings = ref.watch(appProvider).settings;
    return Scaffold(
      backgroundColor: COLOR.greyish_brown_four,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: STYLES.vGradient(theme: settings!.theme),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: padding.top + 10.0),
                  width: size.width,
                  child: NonBorderTextField(
                    height: calcSize(size, 51.0),
                    controller: phoneController,
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    suffixDecoration: code != null
                        ? Container(
                            margin: EdgeInsets.only(right: 8.0),
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: COLOR.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Icon(
                              Icons.phone,
                              color: COLOR.white,
                              size: 16.0,
                            ),
                          )
                        : null,
                    node: node,
                    autoFocus: true,
                    hint: 'Teléfono',
                    hintStyle: FONT.TITLE.merge(
                      TextStyle(
                        color: COLOR.white.withOpacity(0.35),
                        fontSize: 24.0,
                      ),
                    ),
                    type: TextInputType.numberWithOptions(
                        decimal: false, signed: false),
                    insidePadding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 9.0),
                    align: TextAlign.left,
                    style: FONT.TITLE.merge(
                      TextStyle(
                        color: COLOR.white,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: padding.bottom,
            left: 0.0,
            child: Container(
              width: size.width,
              color: COLOR.greyish_brown_four,
              padding: EdgeInsets.symmetric(horizontal: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FooterButton(
                    action: () {
                      node.unfocus();
                      Timer(Duration(milliseconds: 200), () {
                        Application.router.pop(context);
                      });
                    },
                    icon: EmployIcons.btm_close_dark,
                    size: calcSize(size, 60.0),
                    theme: Brightness.light,
                  ),
                  FooterButton(
                    action: () {
                      Navigator.of(context)
                          .pop<ProfilePhonePageBack>(ProfilePhonePageBack(
                        code: code ?? '',
                        phone: phoneController.text,
                      ));
                    },
                    icon: EmployIcons.btm_check_dark,
                    size: calcSize(size, 60.0),
                    theme: Brightness.light,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
