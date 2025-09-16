part of employ.pages;

class EmployTicket extends ConsumerStatefulWidget {
  final String? company;
  final String? id;

  const EmployTicket({this.company, this.id});

  @override
  _EmployTicketState createState() => _EmployTicketState();
}

class _EmployTicketState extends ConsumerState<EmployTicket> {
  bool filterInitialized = false;
  bool dataIsVisible = false;

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
                  text: 'Chats',
                  onFilter: showFilters,
                ),
                Container(
                  height: size.height - calcSize(size, 116),
                  width: size.width,
                  child: StreamBuilder<DatabaseEvent>(
                    stream: Ticket.getStream(
                      db.admin,
                      manager.company!,
                      manager.employee!,
                    ),
                    builder: (context, snapshot) {
                      if (dataIsVisible &&
                          snapshot.hasData &&
                          snapshot.data?.snapshot.value != null) {
                        DatabaseEvent data = snapshot.data!;
                        List<Ticket> documents = [];
                        Map<String, dynamic> value = Map.from(
                          data.snapshot.value?.toDynamic(),
                        );
                        value.keys.forEach(
                          (i) => documents.add(Ticket.fromJson(value[i])),
                        );
                        Ticket.sort(documents);
                        
                        //---------- BEGIN ----------//
                        // Extraer tipos únicos para el filtro
                        Set<String> uniqueTypes = documents
                            .map((ticket) => ticket.name)
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
                        
                        documents = Ticket.filter(
                            documents,
                            filters.year,
                            filters.state == 'Todos',
                            filters.state == 'Abiertos',
                            //---------- BEGIN ----------//
                            filters.type,
                            //---------- FINISH ----------//
                            );
                        if (documents.length == 0)
                          return renderEmptyState(snapshot.connectionState);
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                          shrinkWrap: true,
                          addAutomaticKeepAlives: true,
                          itemCount: documents.length,
                          itemBuilder: (context, int index) {
                            Ticket current = documents[index];
                            return TicketItem(
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
              ],
            ),
            !dataIsVisible ? renderDotLoading(size) : Container()
          ],
        ),
      ),
    );
  }

  void navigateToDocument(Ticket item) {
    final menu = ref.read(menuProvider);
    if (menu.isShown) return;
    Vibration.vibrate(duration: 100);
    String route = Routes.ticket
        .replaceAll(':name', item.name)
        .replaceAll(':id', item.id)
        .replaceAll(':open', item.open.toString());
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
    if (!filterInitialized && mounted) {
      filterInitialized = true;
      Timer(Duration(milliseconds: 200), () {
        if (mounted) {
          final manager = ref.read(appProvider);
          final filtersNotifier = ref.read(filterProvider.notifier);
          int year = DateTime.now().year + 1;
          int createdYear = manager.company!.created.year;
          filtersNotifier.setYears(
            List.generate((year + 1) - createdYear, (i) {
              return createdYear + i;
            }).reversed.toList(),
          );
          filtersNotifier.setStates(['Todos', 'Abiertos', 'Cerrados']);
          filtersNotifier.setState('Todos');
          filtersNotifier.setYear(DateTime.now().year);
        }
      });
    }
  }

  Container renderEmptyState(ConnectionState state) {
    return Container(alignment: Alignment.center);
  }
}
