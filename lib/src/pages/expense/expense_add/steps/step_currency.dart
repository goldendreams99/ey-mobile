import 'package:employ/src/components/index.dart';
import 'package:employ/src/models/expense/currency/expense_currency.dart';
import 'package:employ/src/pages/expense/expense_add/provider/expense_add_provider.dart';
import 'package:employ/src/pages/index.dart';
import 'package:employ/src/theme/index.dart';
import 'package:employ/src/types/int.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseAddStepCurrency extends ConsumerWidget {
  const ExpenseAddStepCurrency({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(
      expenseAddProvider.select((state) => state.currency),
    );
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 26.0),
              child: InkResponse(
                onTap: () => onSelectCurrency(
                  context: context,
                  ref: ref,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: COLOR.black.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: EdgeInsets.only(left: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        currency == null ? "Moneda" : currency.name!,
                        textAlign: TextAlign.right,
                        style: FONT.TITLE.merge(getTextStyle(currency)),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0.0, 11.35, 0.0, 11.35),
                        height: 55.0,
                        width: 55.0,
                        decoration: BoxDecoration(
                          color: COLOR.black.withOpacity(0.2),
                          borderRadius: BorderRadius.only(
                            bottomRight: const Radius.circular(5.0),
                            topRight: const Radius.circular(5.0),
                          ),
                        ),
                        child: Icon(
                          EmployIcons.chevron_right,
                          color: COLOR.white.withOpacity(
                            currency == null ? 0.4 : 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle getTextStyle(ExpenseCurrency? field) {
    return TextStyle(
      color: COLOR.white.withOpacity(field == null ? 0.4 : 1.0),
      fontSize: 22.0,
    );
  }

  void onSelectCurrency({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final options = ref.read(expenseAddProvider).currencies;
    final currency = ref.read(expenseAddProvider).currency;
    Navigator.push<ExpenseCurrency?>(
      context,
      SlideRightRoute(
        widget: EmploySelect<ExpenseCurrency>(
          title: 'Tipo de moneda',
          options: options,
          selected: currency,
          render: (option) => option.name ?? '',
        ),
      ),
    ).then((values) {
      if (values != null) {
        ref.read(expenseAddProvider.notifier).setCurrency(values);
      }
    });
  }
}
