import 'package:employ/src/components/index.dart';
import 'package:employ/src/pages/expense/expense_add/provider/expense_add_provider.dart';
import 'package:employ/src/pages/index.dart';
import 'package:employ/src/theme/index.dart';
import 'package:employ/src/types/int.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseAddStepAmount extends ConsumerStatefulWidget {
  const ExpenseAddStepAmount({Key? key}) : super(key: key);

  @override
  _ExpenseAddStepAmountState createState() => _ExpenseAddStepAmountState();
}

class _ExpenseAddStepAmountState extends ConsumerState<ExpenseAddStepAmount> {
  @override
  Widget build(BuildContext context) {
    final amount = ref.watch(
      expenseAddProvider.select((value) => value.amount?.toString()),
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          InkResponse(
            onTap: () {
              openTextControl(amount);
            },
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
                  Icon(
                    EmployIcons.currency,
                    color: COLOR.white.withOpacity(
                      amount == null ? 0.4 : 1.0,
                    ),
                    size: 27.0,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 16.0),
                      alignment: Alignment.centerRight,
                      child: Text(
                        amount == null ? "0,00" : amount.toString(),
                        textAlign: TextAlign.right,
                        style: FONT.TITLE.merge(
                          getTextStyle(amount),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 11.35, 0.0, 11.35),
                    height: 55.0,
                    width: 55.0,
                    decoration: BoxDecoration(
                      color: COLOR.black.withOpacity(0.13),
                      borderRadius: BorderRadius.only(
                        bottomRight: const Radius.circular(5.0),
                        topRight: const Radius.circular(5.0),
                      ),
                    ),
                    child: Icon(
                      EmployIcons.chevron_right,
                      color: COLOR.white.withOpacity(
                        amount == null ? 0.4 : 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openTextControl(String? amount) {
    Navigator.push<String?>(
      context,
      SlideRightRoute(
        widget: ExpenseAmountPage(amount: amount),
      ),
    ).then((newValue) {
      if (newValue != null) {
        ref
            .read(expenseAddProvider.notifier)
            .setAmount(double.tryParse(newValue));
      }
    });
  }

  TextStyle getTextStyle(dynamic field) {
    return TextStyle(
      color: COLOR.white.withOpacity(field == null ? 0.4 : 1.0),
      fontSize: 22.0,
    );
  }
}
