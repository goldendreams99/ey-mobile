import 'package:date_format/date_format.dart';
import 'package:employ/src/components/index.dart';
import 'package:employ/src/config/application.dart';
import 'package:employ/src/models/expense/cost_center/expense_cost_center.dart';
import 'package:employ/src/pages/expense/expense_add/provider/expense_add_provider.dart';
import 'package:employ/src/pages/index.dart';
import 'package:employ/src/providers/calendar/calendar_provider.dart';
import 'package:employ/src/theme/index.dart';
import 'package:employ/src/types/int.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseAddStepDate extends ConsumerStatefulWidget {
  const ExpenseAddStepDate();

  @override
  _ExpenseAddStepDateState createState() => _ExpenseAddStepDateState();
}

class _ExpenseAddStepDateState extends ConsumerState<ExpenseAddStepDate> {
  String? date;
  List<String> format = [dd, ' ', M, ' ', yyyy];

  @override
  Widget build(BuildContext context) {
    final date = ref.watch(
      expenseAddProvider.select((value) => value.date),
    );
    final costCenter = ref.watch(
      expenseAddProvider.select((value) => value.costCenter),
    );
    final reimbursable = ref.watch(
      expenseAddProvider.select((value) => value.reimbursable),
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 26.0),
            child: InkResponse(
              onTap: () => openCalendar(date),
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
                      Icons.calendar_today,
                      color: COLOR.white.withOpacity(
                        date == null ? 0.4 : 1.0,
                      ),
                      size: 27.0,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          date == null
                              ? "Fecha Factura"
                              : formatDate(date, [
                                  dd,
                                  ' ',
                                  (months[date.month - 1]).substring(0, 3),
                                  ' ',
                                  yyyy
                                ]),
                          textAlign: TextAlign.left,
                          style: FONT.TITLE.merge(
                            TextStyle(
                                color: COLOR.white.withOpacity(
                                  date == null ? 0.4 : 1.0,
                                ),
                                fontSize: 22.0),
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
                          date == null ? 0.4 : 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // CENTRO DE COSTO - Copiado exactamente de step_cost_center.dart
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
                            ? "Centro de Costo"
                            : costCenter.name!,
                        textAlign: TextAlign.right,
                        style: FONT.TITLE.merge(getTextStyleCostCenter(costCenter)),
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
          // REEMBOLSABLE - Copiado exactamente de step_reimbursable.dart
          Container(
            margin: EdgeInsets.only(bottom: 26.0),
            child: Container(
              decoration: BoxDecoration(
                color: COLOR.black.withOpacity(0.13),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Reembolsable",
                    textAlign: TextAlign.right,
                    style: FONT.TITLE.merge(getTextStyleReimbursable('')),
                  ),
                  Switch(
                    value: reimbursable ?? false,
                    inactiveThumbColor: COLOR.white,
                    inactiveTrackColor: Colors.grey,
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
    );
  }

  void openCalendar(DateTime? date) {
    final managerNotifier = ref.read(calendarProvider.notifier);
    if (date != null) {
      managerNotifier.setFrom(date);
    }
    managerNotifier.setPeriod(false);
    Navigator.push(
      context,
      SlideRightRoute(
        widget: ExpenseCalendar(
          onSelectDays: (days) {
            ref.read(expenseAddProvider.notifier).setDate(days.from);
          },
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

  TextStyle getTextStyleCostCenter(dynamic field) {
    return TextStyle(
      color: COLOR.white.withOpacity(field == null ? 0.4 : 1.0),
      fontSize: 22.0,
    );
  }

  TextStyle getTextStyleReimbursable(dynamic field) {
    return TextStyle(
      color: COLOR.white.withOpacity(field == null ? 0.4 : 1.0),
      fontSize: 22.0,
    );
  }
}
