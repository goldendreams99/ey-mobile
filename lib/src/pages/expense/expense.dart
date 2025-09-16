part of employ.pages;

class EmployExpense extends ConsumerStatefulWidget {
  final String? company;
  final String? id;

  const EmployExpense({this.company, this.id});

  @override
  _EmployExpenseState createState() => _EmployExpenseState();
}

class _EmployExpenseState extends ConsumerState<EmployExpense> {
  bool filterInitialized = false;
  bool dataIsVisible = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1000), () {
      dataIsVisible = true;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final manager = ref.watch(appProvider);
    final Database db = EmployProvider.of(context).database;
    final filters = ref.watch(filterProvider);
    initFilters();
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
                  text: 'Gastos',
                  onFilter: showFilters,
                ),
                if (manager.valid)
                  Container(
                    height: size.height - calcSize(size, 116),
                    width: size.width,
                    child: StreamBuilder<DatabaseEvent>(
                      stream: Expense.getStream(
                        db.admin,
                        manager.company!,
                        manager.employee!,
                      ),
                      builder: (context, snapshot) {
                        if (dataIsVisible &&
                            snapshot.hasData &&
                            snapshot.data?.snapshot.value != null) {
                          final data =
                              snapshot.data!.snapshot.value!.toDynamic();
                          List<Expense> documents = [];
                          data.keys.forEach(
                            (k) {
                              final value = data[k];
                              documents.add(Expense.fromJson(value));
                            },
                          );
                          Expense.sort(documents);
                          
                          //---------- BEGIN ----------//
                          // Extraer tipos únicos para el filtro
                          Set<String> uniqueTypes = documents
                              .map((expense) => expense.type?.name ?? '')
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
                          
                          documents = Expense.filter(
                            documents,
                            filters.year,
                            filters.state == 'Todas',
                            filters.state == 'Pendientes',
                            filters.state == 'Aprobadas',
                            filters.state == 'Rechazadas',
                            //---------- BEGIN ----------//
                            filters.type,
                            //---------- FINISH ----------//
                          );
                          if (documents.length == 0) {
                            return renderEmptyState(snapshot.connectionState);
                          }
                          return ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 25.0),
                            shrinkWrap: true,
                            addAutomaticKeepAlives: true,
                            itemCount: documents.length,
                            itemBuilder: (context, int index) {
                              Expense current = documents[index];
                              if (current.isRemovable) {
                                return Slidable(
                                  child: ExpenseItem(
                                    item: current,
                                    watchDocument: navigateToDocument,
                                  ),
                                  endActionPane: ActionPane(
                                    motion: ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        label: 'Eliminar',
                                        backgroundColor: COLOR.orangey_red,
                                        icon: Icons.delete,
                                        onPressed: (context) => remove(current.id!),
                                      )
                                    ],
                                  ),
                                );
                              }
                              return ExpenseItem(
                                item: current,
                                watchDocument: navigateToDocument,
                              );
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
              ],
            ),
            !dataIsVisible ? renderDotLoading(size) : Container()
          ],
        ),
      ),
    );
  }

  void navigateToDocument(Expense expense) {
    final menu = ref.read(menuProvider);
    if (menu.isShown) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ExpenseView(expense: expense);
        },
      ),
    );
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
    final filtersNotifier = ref.read(filterProvider.notifier);
    final manager = ref.read(appProvider);
    if (!filterInitialized && mounted) {
      filterInitialized = true;
      Timer(Duration(milliseconds: 200), () {
        if (mounted) {
          int year = DateTime.now().year + 1;
          int createdYear = manager.company!.created.year;
          filtersNotifier.setYears(
            List.generate((year + 1) - createdYear, (i) {
              return createdYear + i;
            }).reversed.toList(),
          );
          filtersNotifier
              .setStates(['Todas', 'Pendientes', 'Aprobadas', 'Rechazadas']);
          filtersNotifier.setState('Todas');
          filtersNotifier.setYear(DateTime.now().year);
        }
      });
    }
  }

  Container renderEmptyState(ConnectionState state) {
    return Container(alignment: Alignment.center);
  }

  void remove(String id) async {
    final manager = ref.read(appProvider);
    final Database db = EmployProvider.of(context).database;
    bool willRemoved = await RemoveExpenseDialog.build(context);
    if (willRemoved)
      await db.remove('client/${manager.company!.id}/expense/$id');
  }
}
