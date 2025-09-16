import 'package:employ/src/components/index.dart';
import 'package:employ/src/models/expense/client/expense_client.dart';
import 'package:employ/src/pages/expense/expense_add/provider/expense_add_provider.dart';
import 'package:employ/src/pages/index.dart';
import 'package:employ/src/theme/index.dart';
import 'package:employ/src/types/int.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseAddStepClient extends ConsumerStatefulWidget {
  const ExpenseAddStepClient();

  @override
  _ExpenseAddStepClientState createState() => _ExpenseAddStepClientState();
}

class _ExpenseAddStepClientState extends ConsumerState<ExpenseAddStepClient> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final viewStepClient = ref.read(expenseAddProvider).viewStepClient;
      if (!viewStepClient) {
        ref.read(expenseAddProvider.notifier).setViewStepClient(
              viewStepClient: true,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final client = ref.watch(
      expenseAddProvider.select((value) => value.client),
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
                onTap: () => onSelectType(client),
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
                        client == null ? "Cliente" : client.name!,
                        textAlign: TextAlign.right,
                        style: FONT.TITLE.merge(getTextStyle(client)),
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
                            client == null ? 0.4 : 1.0,
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

  TextStyle getTextStyle(ExpenseClient? field) {
    return TextStyle(
      color: COLOR.white.withOpacity(field == null ? 0.4 : 1.0),
      fontSize: 22.0,
    );
  }

  void onSelectType(ExpenseClient? type) {
    final options = ref.read(expenseAddProvider).clients;
    Navigator.push<ExpenseClient?>(
      context,
      SlideRightRoute(
        widget: EmploySelect<ExpenseClient>(
          title: 'Cliente',
          options: options,
          selected: type,
          render: (option) => option.name ?? '-',
        ),
      ),
    ).then((value) {
      if (value != null) {
        ref.read(expenseAddProvider.notifier).setClient(client: value);
      }
    });
  }
}
