part of employ.config;

class Routes {
  static String root = '/';
  static String home = '/employ';
  static String update = '/update';
  static String documents = '/documents/:companyId/:employeeId';
  static String document = '/document/:company/:type/:id/:name';
  static String bank = '/bank/:companyId/:employeeId';
  static String licenses = '/licenses/:companyId/:employeeId';
  static String license = '/license/:companyId/:id/:name/:recent';
  static String expenses = '/expenses/:companyId/:employeeId';
  static String expense = '/expense/:companyId/:id';
  static String tickets = '/tickets/:companyId/:employeeId';
  static String ticket = '/ticket/:name/:id/:open';
  static String login = '/sign-in';
  static String config = '/config';
  static String profile = '/profile/:companyId/:employeeId';
  static String onBording = '/intro/:screen';
  static String filter = '/filter';
  static String newLicense = '/license-new';
  static String newExpense = '/expense-new';
  static String newTicket = '/ticket-new';
  static String newAwardCreated = '/award-created';
  static String newTicketEmpty = '/ticket-new.empty/:name';
  static String changePassword = '/change-password';

  /// [FIXED YPF]
  static String inputData = '/inputData';
  static String lendingRequest = '/lendingRequest';

  static void configureRoutes(fluro.FluroRouter router) {
    router.notFoundHandler = fluro.Handler(handlerFunc:
        (BuildContext? context, Map<String, List<String>> params,
            [dynamic object]) {
      print('ROUTE WAS NOT FOUND !!!');
      return null;
    });
    router.define(root, handler: rootHandler);
    router.define(login, handler: loginHandler);
    router.define(home, handler: homeHandler);
    router.define(onBording, handler: onBordingHandler);
    router.define(document, handler: documentHandler);
    router.define(license, handler: licenseHandler);
    router.define(ticket, handler: ticketHandler);
    router.define(newLicense, handler: newLicenseHandler);
    router.define(newTicket, handler: newTicketHandler);
    router.define(newExpense, handler: newExpenseHandler);
    router.define(newTicketEmpty, handler: newTicketEmptyHandler);
    router.define(newAwardCreated, handler: newAwardHandler);
    router.define(filter, handler: filterHandler);
    router.define(login, handler: bankHandler);
    router.define(changePassword, handler: changePasswordHandler);
    router.define(update, handler: updateHandler);

    /// [FIXED YPF]
    router.define(inputData, handler: incomeDataHandler);
    router.define(lendingRequest, handler: leadingRequestHandler);
  }
}
