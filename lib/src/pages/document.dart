part of employ.pages;

class EmployDocument extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmployStorageDocument(
      type: 'Document',
    );
  }
}

class EmployPaycheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmployStorageDocument(
      type: 'Paycheck',
    );
  }
}

class EmployStorageDocument extends ConsumerStatefulWidget {
  final String? company;
  final String type;
  final String? id;

  const EmployStorageDocument({
    this.company,
    this.type = 'Paycheck',
    this.id,
  });

  @override
  _EmployStorageDocumentState createState() => _EmployStorageDocumentState();
}

class _EmployStorageDocumentState extends ConsumerState<EmployStorageDocument> {
  bool dataIsVisible = false;
  List<Document> visibleDocuments = [];

  @override
  void initState() {
    Timer(Duration(milliseconds: 1000), () {
      dataIsVisible = true;
      if (mounted) setState(() {});
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final manager = ref.watch(appProvider);
    final Database db = EmployProvider.of(context).database;
    final filters = ref.watch(filterProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        height: size.height,
        width: size.width,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SimpleAppBar(
                  text: widget.type == 'Paycheck' ? 'Nóminas' : 'Documentos',
                  onFilter: showFilters,
                ),
                manager.valid
                    ? Container(
                        height: size.height - calcSize(size, 116),
                        width: size.width,
                        child: StreamBuilder<DatabaseEvent>(
                          stream: Document.getStream(
                            db.admin,
                            manager.company!,
                            manager.employee!,
                            widget.type.toLowerCase(),
                          ),
                          builder: (context, snapshot) {
                            if (dataIsVisible &&
                                snapshot.hasData &&
                                snapshot.data?.snapshot.value != null) {
                              DatabaseEvent data = snapshot.data!;
                              List<Document> documents = [];
                              Map<dynamic, dynamic> value =
                                  Map.from(data.snapshot.value as dynamic);
                              value.keys.forEach((k) =>
                                  documents.add(Document.fromJson(value[k])));
                              Document.sort(documents);
                              visibleDocuments = List.from(documents);
                              
                              //---------- BEGIN ----------//
                              // Extraer tipos únicos para el filtro
                              Set<String> uniqueTypes = documents
                                  .map((doc) => doc.typeName)
                                  .where((type) => type.isNotEmpty)
                                  .toSet();
                                  
                              if (uniqueTypes.isNotEmpty) {
                                // Ordenar alfabéticamente los tipos únicos
                                List<String> sortedTypes = uniqueTypes.toList()..sort();
                                List<String> typesList = ['Todos', ...sortedTypes];
                                // Delayed update to avoid modifying provider during build
                                Future(() {
                                  ref.read(filterProvider.notifier).setTypes(typesList);
                                  // Asegurar que "Todos" esté seleccionado si el tipo actual no existe en la nueva lista
                                  if (!typesList.contains(ref.read(filterProvider).type)) {
                                    ref.read(filterProvider.notifier).setType('Todos');
                                  }
                                });
                              } else {
                                // No hay tipos, limpiar la lista para que no se muestre el filtro
                                Future(() => ref.read(filterProvider.notifier).setTypes([]));
                              }
                              //---------- FINISH ----------//
                              
                              documents = Document.filter(
                                  documents,
                                  filters.year,
                                  filters.state == 'Todos',
                                  filters.state == 'Pendientes',
                                  //---------- BEGIN ----------//
                                  filters.type
                                  //---------- FINISH ----------//
                                  );
                              if (documents.length == 0)
                                return renderEmptyState(
                                    snapshot.connectionState);
                              return ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 25.0),
                                shrinkWrap: true,
                                addAutomaticKeepAlives: true,
                                itemCount: documents.length,
                                itemBuilder: (context, int index) {
                                  Document current = documents[index];
                                  return DocumentItem(
                                    item: current,
                                    watchDocument: navigateToDocument,
                                  );
                                },
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      )
                    : Container()
              ],
            ),
            !dataIsVisible ? renderDotLoading(size) : Container()
          ],
        ),
      ),
    );
  }

  void navigateToDocument(Document doc) async {
    final menu = ref.read(menuProvider);
    if (menu.isShown) return;
    final manager = ref.read(appProvider);
    if (widget.type == 'Paycheck' && !doc.canSign(visibleDocuments)) {
      Fluttertoast.showToast(
        msg: '  ${LABEL.oldPaychecks}  ',
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }
    String route = Routes.document
        .replaceAll(':company', manager.company!.id)
        .replaceAll(':type', widget.type)
        .replaceAll(':id', doc.id)
        .replaceAll(':name', doc.typeName);
    Application.router.navigateTo(context, route);
  }

  void showFilters() {
    Application.router.navigateTo(
      context,
      Routes.filter,
      transitionDuration: Duration(milliseconds: 200),
      transition: fluro.TransitionType.inFromBottom,
    );
  }

  void initFilters() {
    final filterNotifier = ref.read(filterProvider.notifier);
    final manager = ref.read(appProvider);
    Timer(Duration(milliseconds: 200), () {
      if (mounted) {
        int year = DateTime.now().year + 1;
        int createdYear = manager.company!.created.year;
        filterNotifier.setYears(
          List.generate((year + 1) - createdYear, (i) {
            return createdYear + i;
          }).reversed.toList(),
        );
        filterNotifier.setStates(['Todos', 'Firmados', 'Pendientes']);
        filterNotifier.setState('Todos');
        filterNotifier.setYear(DateTime.now().year);
      }
    });
  }

  Container renderEmptyState(ConnectionState state) {
    return Container(alignment: Alignment.center);
  }

  String get payCheckNameByCountry {
    final manager = ref.read(appProvider);
    switch (manager.company!.country.toLowerCase()) {
      case 'ar':
      case 'uy':
      case 'py':
        return 'Recibos';
      case 'pe':
      case 'bo':
        return 'Boletas';
      case 'co':
        return 'Comprobantes';
      case 'ec':
        return 'Rol de pago';
      default:
        return 'Nóminas';
    }
  }
}
