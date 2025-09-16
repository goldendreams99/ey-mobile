part of employ.data_model;

class CompanySettings {
  final bool portalBankMercadopago;
  final bool portalBankMacro;
  final bool signBioDocument;
  final bool signBioSelfie;
  final bool signBioApprove;
  final bool paycheckSignOnlyAgree;
  final bool changePin;
  final bool moduleLicense;
  final bool moduleExpense;
  final bool moduleAward;
  final bool moduleInbox;
  final bool moduleFeed;
  final bool moduleChatSubject;
  final bool licenseAuthApprover;
  final bool expenseAuthApprover;
  final String? portalBankUrl;
  final String portalBankName;
  final int awardLimitMonthlyTotal;
  final int awardLimitMonthlyEmployee;
  final String theme;
  final bool expenseClient;
  final int? mobileVersion;

  CompanySettings({
    required this.portalBankName,
    required this.portalBankMercadopago,
    required this.portalBankMacro,
    required this.signBioDocument,
    required this.signBioSelfie,
    required this.paycheckSignOnlyAgree,
    required this.signBioApprove,
    required this.changePin,
    required this.moduleLicense,
    required this.moduleExpense,
    required this.moduleAward,
    required this.moduleInbox,
    required this.moduleFeed,
    required this.moduleChatSubject,
    required this.licenseAuthApprover,
    required this.expenseAuthApprover,
    required this.portalBankUrl,
    required this.awardLimitMonthlyTotal,
    required this.awardLimitMonthlyEmployee,
    required this.theme,
    required this.expenseClient,
    required this.mobileVersion,
  });

  CompanySettings.fromJson(dynamic json)
      : portalBankMercadopago = json['portal_bank_mercadopago'] != null &&
            json['portal_bank_mercadopago'],
        portalBankMacro =
            json['portal_bank_macro'] != null && json['portal_bank_macro'],
        portalBankName = json['portal_bank_mercadopago'] != null &&
                json['portal_bank_mercadopago']
            ? 'mercadopago'
            : (json['portal_bank_macro'] != null && json['portal_bank_macro']
                ? 'macro'
                : ''),
        signBioDocument = json['module_sign_bio_document'] != null &&
            json['module_sign_bio_document'],
        signBioSelfie = json['module_sign_bio_selfie'] != null &&
            json['module_sign_bio_selfie'],
        paycheckSignOnlyAgree =
            json['portal_paycheck_sign_only_agree'] != null &&
                json['portal_paycheck_sign_only_agree'],
        signBioApprove = json['module_sign_bio_approve'] != null &&
            json['module_sign_bio_approve'],
        changePin =
            json['portal_change_pin'] != null && json['portal_change_pin'],
        moduleLicense =
            json['module_license'] != null && json['module_license'],
        moduleInbox = json['module_inbox'] != null && json['module_inbox'],
        moduleFeed = json['module_feed'] != null && json['module_feed'],
        moduleExpense =
            json['module_expense'] != null && json['module_expense'],
        moduleChatSubject =
            json['module_chat_subject'] != null && json['module_chat_subject'],
        moduleAward = json['module_award'] != null && json['module_award'],
        licenseAuthApprover = json['license_auth_approver'] != null &&
            json['license_auth_approver'],
        expenseAuthApprover = json['expense_auth_approver'] != null &&
            json['expense_auth_approver'],
        portalBankUrl = json['portal_bank_url'],
        awardLimitMonthlyTotal = json['award_limit_monthly_total'] ?? 5,
        theme = json['mobile_color'] != null &&
                json['mobile_color'].isNotEmpty &&
                json['mobile_color'] != 'random'
            ? json['mobile_color']
            : (['pink', 'purple', 'blue', 'green', 'orange']..shuffle()).first,
        awardLimitMonthlyEmployee = json['award_limit_monthly_employee'] ?? 0,
        expenseClient =
            json['expense_client'] != null && json['expense_client'],
        mobileVersion = json['mobile_version'];

  Map<String, dynamic> toJson() => {
        'portalBankMercadopago': portalBankMercadopago,
        'portalBankMacro': portalBankMacro,
        'signBioDocument': signBioDocument,
        'signBioSelfie': signBioSelfie,
        'signBioApprove': signBioApprove,
        'paycheckSignOnlyAgree': paycheckSignOnlyAgree,
        'changePin': changePin,
        'moduleLicense': moduleLicense,
        'moduleExpense': moduleExpense,
        'moduleFeed': moduleFeed,
        'moduleAward': moduleAward,
        'moduleChatSubject': moduleChatSubject,
        'licenseAuthApprover': licenseAuthApprover,
        'expenseAuthApprover': expenseAuthApprover,
        'portalBankUrl': portalBankUrl,
        'portalBankName': portalBankName,
        'awardLimitMonthlyTotal': awardLimitMonthlyTotal,
        'awardLimitMonthlyEmployee': awardLimitMonthlyEmployee,
        'expenseClient': expenseClient,
        'mobileVersion': mobileVersion,
      };
}
