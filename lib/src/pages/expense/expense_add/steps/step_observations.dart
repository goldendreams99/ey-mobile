import 'package:employ/src/pages/expense/expense_add/provider/expense_add_provider.dart';
import 'package:employ/src/theme/index.dart';
import 'package:employ/src/types/int.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseAddStepObservations extends ConsumerStatefulWidget {
  const ExpenseAddStepObservations({Key? key}) : super(key: key);

  @override
  _ExpenseAddStepObservationsState createState() =>
      _ExpenseAddStepObservationsState();
}

class _ExpenseAddStepObservationsState
    extends ConsumerState<ExpenseAddStepObservations> {
  TextEditingController commentControl = TextEditingController();

  @override
  void initState() {
    super.initState();
    commentControl.text = ref.read(expenseAddProvider).observation ?? "";
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final observation = ref.read(expenseAddProvider).observation;
      if (observation == null) {
        ref.read(expenseAddProvider.notifier).setObservation("");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 5.vh(context)),
            Container(
              margin: EdgeInsets.only(bottom: 12.0),
              child: Container(
                decoration: BoxDecoration(
                    color: COLOR.black.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(5.0)),
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 11.35),
                child: TextField(
                  controller: commentControl,
                  style: inputStyle,
                  maxLength: 140,
                  textInputAction: TextInputAction.done,
                  maxLines: 10,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(140),
                  ],
                  onChanged: (text) {
                    ref.read(expenseAddProvider.notifier).setObservation(text);
                  },
                  decoration: InputDecoration(
                    hintStyle: inputStyle
                        .merge(TextStyle(color: COLOR.white.withOpacity(0.4))),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 18.0,
                    ),
                    hintText: 'Observaciones',
                    border: InputBorder.none,
                    counterText: "",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle get inputStyle {
    return FONT.TITLE.merge(TextStyle(color: COLOR.white, fontSize: 22.0));
  }
}
