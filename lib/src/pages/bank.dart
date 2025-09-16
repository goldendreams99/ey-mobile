part of employ.pages;

class Bank extends StatefulWidget {
  final String? company;
  final String? employee;

  const Bank({this.company, this.employee});

  @override
  _BankState createState() => _BankState();
}

class _BankState extends State<Bank> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
