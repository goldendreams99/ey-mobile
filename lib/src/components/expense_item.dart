part of employ.widgets;

class ExpenseItem extends StatelessWidget {
  final Expense item;
  final Function(Expense) watchDocument;

  const ExpenseItem({
    required this.item,
    required this.watchDocument,
  });

  String formatAmount(double amount) {
    String amountStr = amount.toStringAsFixed(2);
    List<String> parts = amountStr.split('.');
    String integerPart = parts[0];
    String decimalPart = parts[1];
    
    // Agregar separadores de miles
    String formattedInteger = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        formattedInteger += '.';
      }
      formattedInteger += integerPart[i];
    }
    
    return '$formattedInteger,$decimalPart';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => watchDocument(item),
      child: Container(
        width: size.width,
        height: calcSize(size, 80.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: COLOR.very_light_pink_three,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  r'$ ' + formatAmount(item.value ?? 0.0),
                  style: FONT.TITLE.merge(
                    TextStyle(
                        color: COLOR.brownish_grey,
                        fontSize: calcSize(size, 18.0)),
                  ),
                ),
                SizedBox(
                  height: calcSize(size, 8.5),
                ),
                Text(
                  '${item.label}',
                  style: FONT.TITLEMEDIUM.merge(
                    TextStyle(
                        color: COLOR.bluey_grey,
                        fontSize: calcSize(size, 15.0)),
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '',
                  style: FONT.MEDIUM.merge(
                    TextStyle(
                      color: COLOR.brownish_grey,
                      fontSize: calcSize(size, 14.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: calcSize(size, 8.5),
                ),
                Icon(
                  item.isRejected
                      ? Icons.clear
                      : item.isPending
                          ? Icons.done
                          : Icons.done_all,
                  color: item.isRejected
                      ? COLOR.pink_red
                      : item.isPending
                          ? COLOR.blue_grey
                          : COLOR.bright_blue,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
