import 'package:employ/src/components/index.dart';
import 'package:employ/src/models/expense/cost_center/expense_cost_center.dart';
import 'package:employ/src/pages/expense/expense_add/provider/expense_add_provider.dart';
import 'package:employ/src/pages/index.dart';
import 'package:employ/src/theme/index.dart';
import 'package:employ/src/types/int.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseAddStepCostCenter extends ConsumerWidget {
  const ExpenseAddStepCostCenter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final costCenter = ref.watch(
      expenseAddProvider.select((value) => value.costCenter),
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
                onTap: () => onSelectCostCenter(
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
                        costCenter == null
                            ? "Centro de costo"
                            : costCenter.name!,
                        textAlign: TextAlign.right,
                        style: FONT.TITLE.merge(getTextStyle(costCenter)),
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
                            costCenter == null ? 0.4 : 1.0,
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

  void onSelectCostCenter({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final options = ref.read(expenseAddProvider).costCenters;
    final costCenter = ref.read(expenseAddProvider).costCenter;
    Navigator.push<ExpenseCostCenter?>(
      context,
      SlideRightRoute(
        widget: EmploySelect<ExpenseCostCenter>(
          title: 'Centro de costo',
          options: options,
          selected: costCenter,
          render: (option) => option.name ?? '-',
        ),
      ),
    ).then((value) {
      if (value != null) {
        ref.read(expenseAddProvider.notifier).setCostCenter(costCenter: value);
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
