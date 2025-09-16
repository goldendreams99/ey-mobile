part of employ.pages;

class IncomeDataStepSix extends StatefulWidget {
  final Map<String, String> stepSixData;
  final ValueChanged<Map<String, String>> onChanged;

  const IncomeDataStepSix({
    required this.stepSixData,
    required this.onChanged,
  });

  @override
  IncomeDataStepSixState createState() => IncomeDataStepSixState();
}

class IncomeDataStepSixState extends State<IncomeDataStepSix> {
  late List<dynamic> values;
  late List<Map<String, TextEditingController>> controllers;

  @override
  void initState() {
    super.initState();
    if (widget.stepSixData['relationships'] != null) {
      values = jsonDecode(widget.stepSixData['relationships'] ?? '');
      controllers = values.map((v) {
        return {
          'relationship': TextEditingController(text: v['relationship'] ?? ''),
          'name': TextEditingController(text: v['name'] ?? ''),
          'address': TextEditingController(text: v['address'] ?? ''),
          'document': TextEditingController(text: v['document'] ?? ''),
        };
      }).toList();
    } else {
      values = [
        {
          'relationship': null,
          'name': '',
          'address': '',
          'document': '',
        }
      ];
      controllers = [
        {
          'relationship': TextEditingController(text: ''),
          'name': TextEditingController(text: ''),
          'address': TextEditingController(text: ''),
          'document': TextEditingController(text: ''),
        }
      ];
    }
  }

  void openSelect(int index, dynamic item) {
    final selected = {'name': item['relationship'] ?? ''};
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmploySelect<dynamic>(
          title: 'Parentesco',
          options: relationships,
          selected: selected,
          render: (item) => item['name'],
        ),
      ),
    ).then((value) {
      if (value != null) {
        values[index]['relationship'] = value['name'];
        controllers[index]['relationship']?.text = value['name'];
        sendFeedback(index, values[index]);
      }
    });
  }

  void change(int index, String target, dynamic value) async {
    values[index][target] = value;
    controllers[index]['target'] = TextEditingController(text: value);
    sendFeedback(index, values[index]);
  }

  void evaluateNewBlock(int index, dynamic item) {
    if (item == null) return;
    bool isDocEmpty = item['document'].toString().isEmpty;
    bool isNameEmpty = item['name'].isEmpty;
    bool isRelationshipEmpty = item['relationship'] == null;
    bool isAdressEmpty = item['address'] == null;
    int evaluated = index + 1;
    if (isDocEmpty &&
        isNameEmpty &&
        isAdressEmpty &&
        isRelationshipEmpty &&
        values[evaluated] != null) {
      values.removeAt(evaluated);
      controllers.removeAt(evaluated);
      return;
    }
    if ((!isDocEmpty ||
            !isNameEmpty ||
            !isRelationshipEmpty ||
            !isAdressEmpty) &&
        values.length == evaluated) {
      values.add({
        'relationship': null,
        'name': '',
        'address': '',
        'document': '',
      });
      controllers.add({
        'relationship': TextEditingController(text: ''),
        'name': TextEditingController(text: ''),
        'address': TextEditingController(text: ''),
        'document': TextEditingController(text: ''),
      });
      return;
    }
  }

  void searchLocation(int index) async {
    String? p = await resolveLocationDialog(context);
    if (p != null) {
      values[index]['address'] = p;
      controllers[index]['address']?.text = p;
      sendFeedback(index, values[index]);
    }
  }

  void sendFeedback(index, value) {
    evaluateNewBlock(index, value);
    widget.onChanged({'relationship': jsonEncode(values)});
  }

  void remove(index) {
    dynamic val = values[index];
    if (val['relationship'] == null &&
        val['name'].isEmpty &&
        val['address'].isEmpty &&
        val['document'].isEmpty) return;
    values.removeAt(index);
    controllers.removeAt(index);
    sendFeedback(index, null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: values.length,
              padding: EdgeInsets.only(top: 10.0),
              shrinkWrap: true,
              itemBuilder: (context, int index) {
                return RelationShipCard(
                  index: index,
                  value: values[index],
                  controllers: controllers[index],
                  onSelected: openSelect,
                  onChanged: change,
                  onLocation: searchLocation,
                  onRemove: remove,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
