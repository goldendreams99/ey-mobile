part of employ.widgets;

class MainFeed extends ConsumerStatefulWidget {
  @override
  _MainFeedState createState() => _MainFeedState();
}

class _MainFeedState extends ConsumerState<MainFeed> {
  String? profileImagePath;
  List<dynamic> departmentEmployees = [];
  List<dynamic> companyNews = [];
  bool loadingEmployees = true;
  bool loadingNews = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
  }

  void loadData() {
    final manager = ref.read(appProvider);
    final employeeId = manager.employee!.id;
    
    // Cargar imagen de perfil
    final storedImagePath = localStorage.getItem('profile_image_$employeeId');
    if (storedImagePath != null) {
      profileImagePath = storedImagePath;
      if (mounted) setState(() {});
    }
    
    // Cargar empleados del departamento
    loadDepartmentEmployees();
    
    // Cargar novedades de la empresa
    loadCompanyNews();
  }

  void loadDepartmentEmployees() async {
    final manager = ref.read(appProvider);
    final provider = EmployProvider.of(context);
    final company = manager.company;
    
    try {
      String ref = 'client/${company!.id}/employee';
      final result = await provider.database.once(ref);
      
      if (result != null) {
        List<dynamic> allEmployees = [];
        result.forEach((key, value) {
          if (value != null) {
            allEmployees.add({...value, 'id': key});
          }
        });
        
        // Filtrar empleados del mismo departamento
        final currentDepartment = manager.employee!.department;
        if (currentDepartment != null) {
          departmentEmployees = allEmployees.where((emp) {
            return emp['department'] != null && 
                   emp['department']['id'] == currentDepartment['id'] &&
                   emp['id'] != manager.employee!.id; // Excluir al usuario actual
          }).toList();
        }
      }
    } catch (e) {
      print('Error loading department employees: $e');
    }
    
    loadingEmployees = false;
    if (mounted) setState(() {});
  }

  void loadCompanyNews() async {
    final manager = ref.read(appProvider);
    final provider = EmployProvider.of(context);
    final company = manager.company;
    
    try {
      // TEMPORAL: Cargando desde calendar porque no hay novedades
      // NORMALMENTE debe ser: 'client/${company!.id}/news'
      String ref = 'client/${company!.id}/setting/calendar';
      print('Loading from: $ref (TEMPORAL - usando calendar como prueba)');
      final result = await provider.database.once(ref);
      
      print('Calendar result: $result');
      
      if (result != null) {
        companyNews = [];
        
        // Procesar cada evento del calendario
        result.forEach((key, value) {
          print('Calendar item: $key -> $value');
          if (value != null && value['date'] != null && value['name'] != null) {
            companyNews.add({
              'id': value['id'] ?? key,
              'title': value['name'],
              'content': 'Evento: ${value['name']}', // Mostrar que es del calendario
              'created': value['date']
            });
          }
        });
        
        print('Total calendar items loaded: ${companyNews.length}');
        
        // Ordenar por fecha más cercana a la actual
        DateTime now = DateTime.now();
        companyNews.sort((a, b) {
          try {
            DateTime dateA = DateTime.parse(a['created']);
            DateTime dateB = DateTime.parse(b['created']);
            
            // Calcular diferencia absoluta con la fecha actual
            Duration diffA = (dateA.difference(now)).abs();
            Duration diffB = (dateB.difference(now)).abs();
            
            return diffA.compareTo(diffB);
          } catch (e) {
            return 0;
          }
        });
      } else {
        print('No calendar data found');
      }
    } catch (e) {
      print('Error loading company calendar: $e');
    }
    
    loadingNews = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final manager = ref.watch(appProvider);
    final padding = MediaQuery.of(context).padding;

    return Container(
      decoration: BoxDecoration(
        gradient: STYLES.vGradient(theme: manager.settings!.theme),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // HEADER
            _buildHeader(size, manager),
            
            // ACTIONS (solo si hay compañeros de equipo)
            if (!loadingEmployees && departmentEmployees.isNotEmpty)
              _buildActions(size),
            
            // MAIN CONTENT
            Expanded(
              child: _buildMainContent(size),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Size size, dynamic manager) {
    return Container(
      height: calcSize(size, 76.0),
      padding: EdgeInsets.symmetric(horizontal: calcSize(size, 20.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo de la empresa (dinámico desde Firebase)
          Transform.translate(
            offset: Offset(calcSize(size, -5.0), 0),
            child: Container(
              height: calcSize(size, 47.5),
              margin: EdgeInsets.only(right: calcSize(size, 8.0)),
              child: manager.company!.logoNavbarPortal.isNotEmpty
                ? Image.network(
                    manager.company!.logoNavbarPortal,
                    height: calcSize(size, 47.5),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback al logo local si falla la carga
                      return Image.asset(
                        'assets/images/logo.png',
                        height: calcSize(size, 47.5),
                        fit: BoxFit.contain,
                      );
                    },
                  )
                : Image.asset(
                    'assets/images/logo.png',
                    height: calcSize(size, 47.5),
                    fit: BoxFit.contain,
                  ),
            ),
          ),
          
          // Imagen de perfil (solo visual, sin acción)
          Container(
            height: calcSize(size, 42.0),
            width: calcSize(size, 42.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(calcSize(size, 21.0)),
              color: COLOR.white,
              border: Border.all(
                color: COLOR.white.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  color: COLOR.black.withOpacity(0.15),
                  offset: Offset(0, 2),
                  spreadRadius: -1,
                )
              ],
              image: profileImagePath != null
                  ? DecorationImage(
                      image: FileImage(File(profileImagePath!)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: profileImagePath == null
                ? Center(
                    child: GradientText(
                      manager.employee!.shortName,
                      colors: COLOR.gradient[manager.settings!.theme]!,
                      style: FONT.TITLE.merge(
                        TextStyle(fontSize: 15.0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildActions(Size size) {
    return Container(
      height: calcSize(size, 120.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: calcSize(size, 24.0)),
            child: Text(
              'Compañeros de equipo',
              style: FONT.TITLE.merge(
                TextStyle(
                  color: COLOR.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: calcSize(size, 12.0)),
          Container(
            height: calcSize(size, 80.0),
            child: loadingEmployees
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(COLOR.white),
                    ),
                  )
                : departmentEmployees.isEmpty
                    ? Center(
                        child: Text(
                          'No hay otros empleados en tu departamento',
                          style: FONT.REGULAR.merge(
                            TextStyle(
                              color: COLOR.white.withOpacity(0.7),
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: calcSize(size, 24.0)),
                        itemCount: departmentEmployees.length,
                        itemBuilder: (context, index) {
                          final employee = departmentEmployees[index];
                          return _buildEmployeeCard(size, employee);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(Size size, dynamic employee) {
    String firstName = employee['first_name'] ?? '';
    String lastName = employee['last_name'] ?? '';
    String initials = '';
    
    if (firstName.isNotEmpty) initials += firstName[0];
    if (lastName.isNotEmpty) initials += lastName[0];
    
    return Container(
      width: calcSize(size, 70.0),
      margin: EdgeInsets.only(right: calcSize(size, 12.0)),
      child: Column(
        children: [
          Container(
            height: calcSize(size, 50.0),
            width: calcSize(size, 50.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(calcSize(size, 25.0)),
              color: COLOR.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: COLOR.black_20,
                  offset: Offset(0, 2),
                  spreadRadius: -2,
                )
              ],
            ),
            child: Center(
              child: Text(
                initials,
                style: FONT.TITLE.merge(
                  TextStyle(
                    fontSize: 16.0,
                    color: COLOR.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: calcSize(size, 8.0)),
          Text(
            firstName,
            style: FONT.REGULAR.merge(
              TextStyle(
                color: COLOR.white,
                fontSize: 12.0,
              ),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(Size size) {
    return Container(
      margin: EdgeInsets.only(top: calcSize(size, 8.0)),
      decoration: BoxDecoration(
        color: COLOR.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(calcSize(size, 24.0)),
          topRight: Radius.circular(calcSize(size, 24.0)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              calcSize(size, 24.0),
              calcSize(size, 24.0),
              calcSize(size, 24.0),
              calcSize(size, 16.0),
            ),
            child: Text(
              'Novedades',
              style: FONT.TITLE.merge(
                TextStyle(
                  color: COLOR.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            child: loadingNews
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : companyNews.isEmpty
                    ? Center(
                        child: Transform.translate(
                          offset: Offset(0, calcSize(size, -30.0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Icon(
                              Icons.article_outlined,
                              size: calcSize(size, 48.0),
                              color: COLOR.black.withOpacity(0.3),
                            ),
                            SizedBox(height: calcSize(size, 16.0)),
                            Text(
                              'No hay novedades disponibles',
                              style: FONT.REGULAR.merge(
                                TextStyle(
                                  color: COLOR.black.withOpacity(0.6),
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: calcSize(size, 24.0)),
                        itemCount: companyNews.length,
                        itemBuilder: (context, index) {
                          final news = companyNews[index];
                          return _buildNewsCard(size, news);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(Size size, dynamic news) {
    String title = news['title'] ?? 'Sin título';
    String content = news['content'] ?? 'Sin contenido';
    String date = news['created'] ?? '';
    
    return Container(
      margin: EdgeInsets.only(bottom: calcSize(size, 16.0)),
      padding: EdgeInsets.all(calcSize(size, 16.0)),
      decoration: BoxDecoration(
        color: COLOR.white,
        borderRadius: BorderRadius.circular(calcSize(size, 12.0)),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: COLOR.black.withOpacity(0.1),
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: COLOR.black.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: FONT.TITLE.merge(
              TextStyle(
                color: COLOR.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: calcSize(size, 8.0)),
          Text(
            content,
            style: FONT.REGULAR.merge(
              TextStyle(
                color: COLOR.black.withOpacity(0.8),
                fontSize: 14.0,
                height: 1.4,
              ),
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (date.isNotEmpty) ...[
            SizedBox(height: calcSize(size, 12.0)),
            Text(
              _formatDate(date),
              style: FONT.REGULAR.merge(
                TextStyle(
                  color: COLOR.black.withOpacity(0.5),
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      DateTime dateTime = DateTime.parse(date);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return date;
    }
  }
}