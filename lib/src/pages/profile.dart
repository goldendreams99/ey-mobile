part of employ.pages;

class Profile extends ConsumerStatefulWidget {
  final String? company;
  final String? employee;

  const Profile({this.company, this.employee});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  TextEditingController controller = TextEditingController();
  String? version;
  // String? profileImagePath; // TODO: Para funcionalidad futura de imagen de perfil

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final manager = ref.read(appProvider);
      controller.text = manager.employee!.book.phone;
      PackageInfo.fromPlatform().then((info) {
        version = '${info.version} (${info.buildNumber})';
        if (mounted) setState(() {});
      });
      // TODO: Funcionalidad futura - cargar imagen de perfil
      // final employeeId = manager.employee!.id;
      // final storedImagePath = localStorage.getItem('profile_image_$employeeId');
      // if (storedImagePath != null) {
      //   profileImagePath = storedImagePath;
      //   if (mounted) setState(() {});
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final manager = ref.watch(appProvider);
    final padding = MediaQuery.of(context).padding;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: calcSize(size, 29.0)),
            decoration: BoxDecoration(
                gradient: STYLES.vGradient(theme: manager.settings!.theme)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: calcSize(size, 13.5)),
                    alignment: Alignment.bottomLeft,
                    width: size.width,
                    height: calcSize(size, 132.5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          LABEL.profile,
                          style: FONT.TITLE.merge(
                            TextStyle(fontSize: 34.0, color: COLOR.white),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // TODO: Funcionalidad futura - cambio de imagen de perfil
                        // InkResponse(
                        //   onTap: updateProfileImage,
                        //   borderRadius: BorderRadius.circular(calcSize(size, 33.0)),
                        //   child: 
                        Container(
                            margin: EdgeInsets.only(right: 5.0),
                            height: calcSize(size, 66.0),
                            width: calcSize(size, 66.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(calcSize(size, 33.0)),
                                color: COLOR.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 17,
                                    color: COLOR.black_50,
                                    offset: Offset(0, 6),
                                    spreadRadius: -7,
                                  )
                                ],
                                // TODO: Funcionalidad futura - imagen de perfil
                                // image: profileImagePath != null
                                //     ? DecorationImage(
                                //         image: FileImage(File(profileImagePath!)),
                                //         fit: BoxFit.cover,
                                //       )
                                //     : null
                            ),
                            child: GradientText(
                                    manager.employee!.shortName,
                                    colors: COLOR.gradient[manager.settings!.theme]!,
                                    style: FONT.TITLE.merge(
                                      TextStyle(fontSize: 27.0),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                // : null,  // TODO: Comentado para funcionalidad futura
                        ),
                        // ),  // Cierre del InkResponse comentado
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 9.45),
                    width: size.width,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 8.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: COLOR.black.withOpacity(0.13),
                    ),
                    child: Text(
                      manager.employee!.profileName,
                      style: FONT.TITLE.merge(
                        TextStyle(
                          color: COLOR.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 9.45),
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: COLOR.black.withOpacity(0.13),
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Container(
                            padding: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: COLOR.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Icon(
                              Icons.badge,
                              color: COLOR.white,
                              size: 16.0,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0.0, 12.0, 10.0, 8.5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              manager.employee!.document ?? LABEL.documentTag,
                              style: FONT.TITLE.merge(
                                TextStyle(
                                  color: COLOR.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkResponse(
                    onTap: openPhonePage,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 9.45),
                      width: size.width,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: COLOR.black.withOpacity(0.13),
                      ),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Container(
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: COLOR.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Icon(
                                Icons.phone,
                                color: COLOR.white,
                                size: 16.0,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Container(
                              width: size.width * 0.54,
                              child: Text(
                                manager.employee!.book.phone.isNotEmpty
                                    ? manager.employee!.book.phone
                                    : 'Teléfono',
                                maxLines: 1,
                                style: FONT.TITLE.merge(
                                  TextStyle(
                                    color: COLOR.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.fromLTRB(0.0, 11.35, 0.0, 11.35),
                            height: 50.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                              color: COLOR.black.withOpacity(0.13),
                              borderRadius: BorderRadius.only(
                                bottomRight: const Radius.circular(5.0),
                                topRight: const Radius.circular(5.0),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              EmployIcons.chevron_right,
                              color: COLOR.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  manager.employee!.book.mail.isNotEmpty
                      ? Container(
                          margin: EdgeInsets.symmetric(vertical: 9.45),
                          width: size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: COLOR.black.withOpacity(0.13),
                          ),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 15.0),
                                child: Container(
                                  padding: EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    color: COLOR.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Icon(
                                    Icons.email,
                                    color: COLOR.white,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0.0, 12.0, 10.0, 8.5),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    manager.employee!.book.mail,
                                    maxLines: 1,
                                    style: FONT.TITLE.merge(
                                      TextStyle(
                                        color: COLOR.white,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  // Departamento
                  manager.employee!.department != null && 
                  manager.employee!.department is Map &&
                  manager.employee!.department['name'] != null &&
                  manager.employee!.department['name'].toString().isNotEmpty
                      ? Container(
                          margin: EdgeInsets.symmetric(vertical: 9.45),
                          width: size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: COLOR.black.withOpacity(0.13),
                          ),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 15.0),
                                child: Container(
                                  padding: EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    color: COLOR.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Icon(
                                    Icons.business,
                                    color: COLOR.white,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0.0, 12.0, 10.0, 8.5),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    manager.employee!.department['name'].toString(),
                                    maxLines: 1,
                                    style: FONT.TITLE.merge(
                                      TextStyle(
                                        color: COLOR.white,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  hasBiometricData
                      ? Container(
                          margin: EdgeInsets.only(top: 20.0),
                          width: size.width,
                          padding: EdgeInsets.symmetric(horizontal: 2.0),
                          child: InkResponse(
                            onTap: showBiometricInfo,
                            borderRadius: BorderRadius.circular(32.5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: COLOR.very_light_pink_eight,
                                borderRadius: BorderRadius.circular(32.5),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Datos Biométricos",
                                    style: FONT.TITLE.merge(
                                      TextStyle(
                                        color: Color.fromRGBO(88, 88, 88, 1.0),
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Icon(
                                    EmployIcons.fingerprint,
                                    color: Color.fromRGBO(88, 88, 88, 1.0),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          Positioned(
            left: 32.0,
            bottom: padding.bottom + 30.0,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  width: 110.0,
                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                  child: InkResponse(
                    onTap: signOut,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.exit_to_app,
                          color: COLOR.white,
                          size: 32.0,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Container(
                          width: 67.0,
                          child: Text(
                            "Cerrar Sesión",
                            maxLines: 2,
                            style: FONT.TITLE.merge(
                              TextStyle(
                                color: COLOR.white,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                version != null
                    ? Text(
                        'Version: $version',
                        maxLines: 2,
                        style: FONT.TITLE.merge(
                          TextStyle(
                            color: COLOR.white,
                            fontSize: 10.0,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }

  void openPhonePage() {
    final menu = ref.read(menuProvider);
    final employee = ref.read(appProvider).employee;
    final company = ref.read(appProvider).company;
    if (!menu.isShown)
      Navigator.push<ProfilePhonePageBack?>(
        context,
        SlideRightRoute(
          widget: ProfilePhonePage(
            phone: employee!.book.phone,
          ),
        ),
      ).then((value) async {
        if (value != null) {
          final db = EmployProvider.of(context).database;
          String ref = 'client/${company!.id}/employee/${employee.id}/book';
          if (value.code != employee.book.timeZone) {
            await db.update(ref, {'phone_timezone': value.code});
            setState(() {});
          }
          if (value.phone.isNotEmpty) {
            await db.update(ref, {'phone': value.phone});
          }
        }
      });
  }

  void showBiometricInfo() {
    final employee = ref.read(appProvider).employee;
    final menu = ref.read(menuProvider);
    if (!menu.isShown)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => employee!.signplify == null
              ? BiometricSignature()
              : BiometricDataView(
                  signplify: employee.signplify,
                ),
        ),
      );
  }

  void signOut() {
    BottomSheetDialog.build(
      context,
      ref,
      '¿Estás seguro de que quieres cerrar sesión?',
      onAccept: () {
        final app = ref.read(appProvider);
        final provider = EmployProvider.of(context);
        provider.messaging?.unsubscribe(app.employee);
        ref.read(appProvider.notifier).close();
        provider.auth?.signOut();
        Application.router
            .navigateTo(context, Routes.login, replace: true, clearStack: true);
      },
    );
  }

  bool get hasBiometricData {
    final employee = ref.read(appProvider).employee;
    return employee!.modulePaycheckSign == 'bio' ||
        employee.moduleDocumentSign == 'bio' ||
        employee.moduleLicenseSign == 'bio';
  }

  // TODO: Funcionalidad futura - cambio de imagen de perfil
  // void updateProfileImage() {
  //   BottomSheetDialog.build(
  //     context,
  //     ref,
  //     '¿Quieres actualizar tu foto de perfil?',
  //     onAccept: openCamera,
  //   );
  // }

  // Future<void> openCamera() async {
  //   // Cerrar el modal de confirmación primero
  //   Navigator.of(context).pop();
  //   
  //   bool canOpenCamera = await canTakePicture(context);
  //   if (canOpenCamera) {
  //     List<CameraDescription> cameras = await availableCameras();
  //     if (cameras.length > 0) {
  //       // Usar cámara frontal si está disponible, sino la primera disponible
  //       CameraDescription selectedCamera = cameras.firstWhere(
  //         (camera) => camera.lensDirection == CameraLensDirection.front,
  //         orElse: () => cameras.first,
  //       );
  //       
  //       String? imagePath = await Navigator.push<String>(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => CustomCamera(
  //             selectedCamera,
  //             title: 'Foto de Perfil',
  //             fileName: 'profile',
  //           ),
  //         ),
  //       );
  //       
  //       if (imagePath != null) {
  //         final manager = ref.read(appProvider);
  //         final employeeId = manager.employee!.id;
  //         // Guardar la ruta de la imagen en localStorage
  //         localStorage.setItem('profile_image_$employeeId', imagePath);
  //         profileImagePath = imagePath;
  //         if (mounted) setState(() {});
  //       }
  //     }
  //   }
  // }
}
