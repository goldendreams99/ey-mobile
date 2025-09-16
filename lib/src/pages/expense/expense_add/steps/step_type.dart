import 'package:employ/src/components/index.dart';
import 'package:employ/src/models/expense/type/expense_type.dart';
import 'package:employ/src/models/expense/currency/expense_currency.dart';
import 'package:employ/src/pages/expense/expense_add/provider/expense_add_provider.dart';
import 'package:employ/src/pages/index.dart';
import 'package:employ/src/theme/index.dart';
import 'package:employ/src/types/int.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ExpenseAddStepType extends ConsumerWidget {
  const ExpenseAddStepType();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(
      expenseAddProvider.select((value) => value.type),
    );
    final amount = ref.watch(
      expenseAddProvider.select((value) => value.amount?.toString()),
    );
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
                onTap: () => onSelectType(
                  context: context,
                  ref: ref,
                  type: type,
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
                        type == null ? "Tipo de Gasto" : type.name!,
                        textAlign: TextAlign.right,
                        style: FONT.TITLE.merge(getTextStyle(type)),
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
                            type == null ? 0.4 : 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // MONTO - Copiado exactamente de step_amount.dart
            Container(
              margin: EdgeInsets.only(bottom: 26.0),
              child: InkResponse(
                onTap: () {
                  openTextControl(context, ref, amount);
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
                            amount == null ? "0,00" : formatAmount(double.tryParse(amount) ?? 0.0),
                            textAlign: TextAlign.right,
                            style: FONT.TITLE.merge(
                              getTextStyleAmount(amount),
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
            ),
            // MONEDA - Copiado exactamente de step_currency.dart
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
                        style: FONT.TITLE.merge(getTextStyleCurrency(currency)),
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

  TextStyle getTextStyle(ExpenseType? field) {
    return TextStyle(
      color: COLOR.white.withOpacity(field == null ? 0.4 : 1.0),
      fontSize: 22.0,
    );
  }

  TextStyle getTextStyleAmount(dynamic field) {
    return TextStyle(
      color: COLOR.white.withOpacity(field == null ? 0.4 : 1.0),
      fontSize: 22.0,
    );
  }

  TextStyle getTextStyleCurrency(ExpenseCurrency? field) {
    return TextStyle(
      color: COLOR.white.withOpacity(field == null ? 0.4 : 1.0),
      fontSize: 22.0,
    );
  }

  void onSelectType({
    required BuildContext context,
    required WidgetRef ref,
    required ExpenseType? type,
  }) {
    final options = ref.read(expenseAddProvider).types;
    Navigator.push<ExpenseType?>(
      context,
      SlideRightRoute(
        widget: EmploySelect<ExpenseType>(
          title: 'Tipo de Gasto',
          options: options,
          selected: type,
          render: (option) => option.name ?? '-',
        ),
      ),
    ).then((value) {
      if (value != null) {
        ref.read(expenseAddProvider.notifier).setType(type: value);
      }
    });
  }

  void openTextControl(BuildContext context, WidgetRef ref, String? amount) {
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

  String formatAmount(double amount) {
    // Separar parte entera y decimal
    String amountStr = amount.toStringAsFixed(2);
    List<String> parts = amountStr.split('.');
    String integerPart = parts[0];
    String decimalPart = parts[1];
    
    // Agregar separador de miles (puntos) cada 3 dígitos de derecha a izquierda
    String formattedInteger = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        formattedInteger += '.';
      }
      formattedInteger += integerPart[i];
    }
    
    return '$formattedInteger,$decimalPart';
  }
}
