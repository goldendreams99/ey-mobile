import 'package:employ/src/pages/expense/expense_add/provider/expense_add_provider.dart';
import 'package:employ/src/theme/index.dart';
import 'package:employ/src/types/int.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseAddStepReimbursable extends ConsumerStatefulWidget {
  const ExpenseAddStepReimbursable();

  @override
  _ExpenseAddStepReimbursableState createState() =>
      _ExpenseAddStepReimbursableState();
}

class _ExpenseAddStepReimbursableState
    extends ConsumerState<ExpenseAddStepReimbursable> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final reimbursable = ref.read(expenseAddProvider).reimbursable;
      if (reimbursable == null) {
        ref
            .read(expenseAddProvider.notifier)
            .setReimbursable(reimbursable: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final reimbursable = ref.watch(
      expenseAddProvider.select((value) => value.reimbursable),
    );
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: <Widget>[
            Container(
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
                      "Reembolsable",
                      textAlign: TextAlign.right,
                      style: FONT.TITLE.merge(getTextStyle('')),
                    ),
                    Switch(
                      value: reimbursable ?? false,
                      inactiveThumbColor: COLOR.white,
                      activeColor: COLOR.white,
                      activeTrackColor: Color.fromRGBO(63, 192, 59, 1.0),
                      onChanged: (v) {
                        ref.read(expenseAddProvider.notifier).setReimbursable(
                            reimbursable: !(reimbursable ?? false));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle getTextStyle(dynamic field) {
    return TextStyle(
      color: COLOR.white.withOpacity(field == null ? 0.4 : 1.0),
      fontSize: 22.0,
    );
  }
}
