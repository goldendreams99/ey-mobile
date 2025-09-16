import 'package:employ/app.dart';
import 'package:employ/src/components/dialogs/bottom_sheet_dialog.dart';
import 'package:employ/src/components/index.dart';
import 'package:employ/src/config/application.dart';
import 'package:employ/src/models/expense/attachment/expense_attachment.dart';
import 'package:employ/src/pages/expense/expense_add/provider/expense_add_provider.dart';
import 'package:employ/src/pages/expense/expense_add/steps/step_attachments.dart';
import 'package:employ/src/pages/expense/expense_add/steps/step_client.dart';
import 'package:employ/src/pages/expense/expense_add/steps/step_cost_center.dart';
import 'package:employ/src/pages/expense/expense_add/steps/step_currency.dart';
import 'package:employ/src/pages/expense/expense_add/steps/step_date.dart';
import 'package:employ/src/pages/expense/expense_add/steps/step_observations.dart';
import 'package:employ/src/pages/expense/expense_add/steps/step_reimbursable.dart';
import 'package:employ/src/pages/expense/expense_add/steps/step_type.dart';
import 'package:employ/src/providers/app/app_provider.dart';
import 'package:employ/src/providers/index.dart';
import 'package:employ/src/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class ExpenseAdd extends ConsumerStatefulWidget {
  final DateTime? date;
  final String? amount;
  final String? image;
  final bool fromScan;

  const ExpenseAdd({this.date, this.amount, this.image, this.fromScan = false, Key? key})
      : super(key: key);

  @override
  _ExpenseAddState createState() => _ExpenseAddState();
}

class _ExpenseAddState extends ConsumerState<ExpenseAdd>
    with SingleTickerProviderStateMixin {
  List<ExpenseAttachment> uploadbleAttachments = [];
  int index = 0;
  bool doing = false;
  bool? showStepClient;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final company = ref.read(appProvider).company;
      final provider = EmployProvider.of(context);
      ref.read(expenseAddProvider.notifier).fetchSetting(
            company: company!,
            provider: provider,
          );
    });
  }

  @override
  void dispose() {
    ref.invalidate(expenseAddProvider);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final manager = ref.watch(appProvider);
    final bool isKeyboardShown =
        MediaQuery.of(context).viewInsets.bottom == 0.0;
    final size = MediaQuery.of(context).size;
    showStepClient = manager.settings?.expenseClient;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: showStepClient == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    height: size.height,
                    width: size.width,
                    decoration: BoxDecoration(
                      gradient:
                          STYLES.vGradient(theme: manager.settings!.theme),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: EmployStepper(
                        title: 'Nuevo Gasto',
                        showActions: isKeyboardShown,
                        steps: availableSteps,
                        textColor: COLOR.gradient[manager.settings!.theme]![1],
                        currentStep: index,
                        swipeable: false,
                        visibleSteps: 5,
                        onStepTapped: (i) {
                          index = i;
                          setState(() {});
                        },
                        onStepCancel: () {
                          ref.invalidate(expenseAddProvider);
                          Application.router.pop(context);
                          if (mounted && widget.fromScan) {
                            Application.router.pop(context);
                          }
                        },
                        onStepContinue: upLoadExpense,
                      ),
                    ),
                  ),
                  Container(
                    decoration: doing
                        ? BoxDecoration(
                            gradient: STYLES.vGradient(
                                theme: manager.settings!.theme),
                          )
                        : null,
                    child: doing ? renderDotLoading(size) : null,
                  ),
                ],
              ),
      ),
    );
  }

  void close() async {
    ref.invalidate(expenseAddProvider);
    Application.router.pop(context);
  }

  void create() async {
    try {
      setState(() {
        doing = true;
      });
      final data = ref.read(expenseAddProvider);
      if (data.attachments.length > 0) {
        addAttachments(data.attachments);
      } else {
        generateSnapShop(attachments: uploadbleAttachments);
      }
    } catch (e) {
      BottomSheetDialog.build(
        context,
        ref,
        'Uhh.. error al crear el gasto, intentá nuevamente más tarde',
      );
      if (widget.fromScan) Application.router.pop(context);
      Application.router.pop(context);
    }
  }

  Future<void> generateSnapShop({
    required List<ExpenseAttachment> attachments,
  }) async {
    final manager = ref.read(appProvider);
    final employ = EmployProvider.of(context);
    final config = AppConfig.of(context);
    await ref.read(expenseAddProvider.notifier).saveExpense(
          manager: manager,
          employ: employ,
          config: config,
          attachments: attachments,
        );
    Fluttertoast.showToast(
      msg: 'Gasto creado',
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
    ref.invalidate(expenseAddProvider);
    if (widget.fromScan) Application.router.pop(context);
    Application.router.pop(context);
  }

  void addAttachments(List<dynamic> attachments) {
    final company = ref.read(appProvider).company!;
    final storage = EmployProvider.of(context).storage;
    String path = 'client/${company.id}/employee/expense_attach';
    List.from(attachments).forEach((file) {
      String id = '${Uuid().v1()}.jpg';
      String name = file.substring(file.lastIndexOf('/') + 1);
      storage?.upload(
        file,
        '$path/$id',
        (url) => loadAttachment(url, name, id, attachments.length),
      );
    });
  }

  void loadAttachment(String url, String name, String id, int size) async {
    uploadbleAttachments.add(
      ExpenseAttachment(
        id: id,
        name: name,
        url: url,
        type: name.toLowerCase().endsWith('pdf')
            ? 'application/pdf'
            : 'image/jpg',
      ),
    );
    if (uploadbleAttachments.length == size) {
      generateSnapShop(attachments: uploadbleAttachments);
    }
  }

  List<EmployStep> get availableSteps {
    final data = ref.read(expenseAddProvider);
    List<EmployStep> list = [];
    list.add(
      EmployStep(
        state: data.type != null && data.amount != null && data.currency != null
            ? EmployStepState.complete
            : EmployStepState.indexed,
        content: ExpenseAddStepType(),
      ),
    );
    list.add(
      EmployStep(
        state: data.date != null && data.costCenter != null
            ? EmployStepState.complete
            : EmployStepState.indexed,
        content: ExpenseAddStepDate(),
      ),
    );
    list.add(
      EmployStep(
        state: data.attachments.isNotEmpty && data.observation != null
            ? EmployStepState.complete
            : EmployStepState.indexed,
        content: ExpenseAddStepAttachments(),
      ),
    );
    if (showStepClient == true) {
      list.add(
        EmployStep(
          state: data.viewStepClient
              ? EmployStepState.complete
              : EmployStepState.indexed,
          content: ExpenseAddStepClient(),
        ),
      );
    }
    return list;
  }

  void upLoadExpense() {
    EmployStep? step;
    try {
      step =
          availableSteps.firstWhere((s) => s.state == EmployStepState.indexed);
    } catch (e) {
      step = null;
    }
    if (step != null && index == availableSteps.length - 1) {
      final data = ref.read(expenseAddProvider);
      String message = 'error';

      if (data.observation == null) message = "Ingresá las observaciones";
      if (data.attachments.isEmpty)
        message = "Adjuntá al menos una foto o archivo";
      if (data.costCenter == null) message = "Seleccioná el centro de costo";
      if (data.date == null) message = "Seleccioná la fecha del gasto";
      if (data.currency == null) message = "Seleccioná el tipo de moneda";
      if ((data.amount ?? 0) <= 0.0)
        message = 'Ups.. el monto a informar debe ser mayor a 0';
      if (data.amount == null) message = "Ingresá el monto";
      if (data.type == null) message = "Seleccioná el tipo de gasto";

      Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
    } else if (step == null) {
      create();
    }
  }
}
