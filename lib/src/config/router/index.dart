part of employ.config;

var rootHandler = fluro.Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return Root();
  },
);
var homeHandler = fluro.Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return Home();
  },
);
var onBordingHandler = fluro.Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return OnBording(screen: params['screen'][0]);
  },
);
var loginHandler = fluro.Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return Login();
  },
);
var filterHandler = fluro.Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return Filter();
  },
);
var bankHandler = fluro.Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return Bank(
      company: params["companyId"][0],
      employee: params["employeeId"][0],
    );
  },
);
var updateHandler = fluro.Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return UpdateApp();
  },
);
var changePasswordHandler = fluro.Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return ChangePassword();
  },
);
var documentHandler = fluro.Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return DocumentView(
      documentId: params["id"][0],
      companyId: params["company"][0],
      category: params["type"][0],
      name: params["name"][0],
    );
  },
);
var licenseHandler = fluro.Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return LicenseView(
      licenseId: params["id"]?[0],
      companyId: params["companyId"]?[0],
      name: params["name"]?[0],
      isRecent: params["recent"][0] == 'true',
    );
  },
);
var ticketHandler = fluro.Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return TicketView(
      ticketId: params["id"][0],
      name: params["name"][0],
      isOpen: params["open"][0],
    );
  },
);
var newTicketEmptyHandler = fluro.Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return TicketViewEmpty(
      name: params["name"][0],
    );
  },
);
var newLicenseHandler = fluro.Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return LicenseAdd();
  },
);
var newTicketHandler = fluro.Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return TicketAdd();
  },
);
var newExpenseHandler = fluro.Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    final data = context?.arguments as Map<String, dynamic>;
    return ExpenseAdd(
      date: data['date'],
      amount: data['amount'],
      image: data['file'],
      fromScan: data['fromScanner'],
    );
  },
);
var newAwardHandler = fluro.Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    final data = context?.arguments as Map<String, dynamic>;
    return AwardCreated(
      award: data['item'],
    );
  },
);

/// [FIXED YPF]
var incomeDataHandler = fluro.Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
      IncomeData(),
);
var leadingRequestHandler = fluro.Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
      LeadingRequest(),
);
