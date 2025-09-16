part of employ.config;

class ChangeEmployeeAction {
  final Employee employee;

  ChangeEmployeeAction(this.employee);

  Map<String, dynamic> toJson() => {
        'type': 'ChangeEmployee',
        'payload': employee,
      };
}

class RemoveEmployeeAction {
  Map<String, dynamic> toJson() => {
        'type': 'RemoveEmployee',
        'payload': null,
      };
}

class ChangeCompanyAction {
  final Company company;

  ChangeCompanyAction(this.company);

  Map<String, dynamic> toJson() => {
        'type': 'RemoveEmployee',
        'payload': company,
      };
}

class RemoveCompanyAction {
  Map<String, dynamic> toJson() => {
        'type': 'RemoveCompany',
        'payload': null,
      };
}

class ChangeCompanySettingsAction {
  final CompanySettings settings;

  ChangeCompanySettingsAction(this.settings);

  Map<String, dynamic> toJson() => {
        'type': 'ChangeCompanySettings',
        'payload': settings,
      };
}

class RemoveCompanySettingsAction {
  Map<String, dynamic> toJson() => {
        'type': 'RemoveCompanySettings',
        'payload': null,
      };
}
