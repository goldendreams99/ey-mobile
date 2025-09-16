part of employ.pages;

class EmployInbox extends ConsumerStatefulWidget {
  final String? company;
  final String type;
  final String? id;

  const EmployInbox({this.company, this.type = 'Paycheck', this.id});

  @override
  _EmployInboxState createState() => _EmployInboxState();
}

class _EmployInboxState extends ConsumerState<EmployInbox> {
  late List<dynamic> options;

  @override
  void initState() {
    super.initState();
    options = [
      {
        'text': 'Datos de Ingreso',
        'subText': '22/02/2019',
        'icon': Icon(
          Icons.done,
          color: COLOR.blue_grey,
        ),
        'tag': 'Hoy',
        'onView': () async {
          bool store = await canWriteOnStorage(context);
          bool camera = await canTakePicture(context);
          bool location = await canUserLocation(context);
          if (store && camera && location) showScreen(Routes.inputData);
        },
      },
      {
        'text': 'Solicitud de Préstamo',
        'subText': '22/02/2019',
        'icon': Icon(Icons.done_all, color: COLOR.bright_blue),
        'tag': 'Hoy',
        'onView': () => showScreen(Routes.lendingRequest),
      }
    ];
  }

  void showScreen(String route) {
    final menu = ref.read(menuProvider);
    if (menu.isShown) return;
    Application.router.navigateTo(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SimpleAppBar(
            text: 'Inbox',
            hasAction: false,
            onFilter: () {},
          ),
          Container(
            height: size.height - calcSize(size, 116),
            width: size.width,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              shrinkWrap: true,
              addAutomaticKeepAlives: true,
              itemCount: options.length,
              itemBuilder: (context, int index) {
                dynamic current = options[index];
                return FixedListItem(
                  text: current['text'],
                  subText: current['subText'],
                  icon: current['icon'],
                  tag: current['tag'],
                  onView: current['onView'],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
