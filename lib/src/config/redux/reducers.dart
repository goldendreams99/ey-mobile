// part of employ.config;

// AppState appStateReducer(AppState state, action) {
//   return AppState(
//     employee: employeeReducer(state.employee, action),
//     company: companyReducer(state.company, action),
//     settings: settingsReducer(state.settings, action),
//   );
// }

// Employee employeeReducer(Employee state, action) {
//   if (action is ChangeEmployeeAction) {
//     Employee e = Employee.fromJson(action.employee);
//     return e;
//   }
//   if (action is RemoveEmployeeAction) return null;
//   return state;
// }

// Company companyReducer(Company state, action) {
//   if (action is ChangeCompanyAction) return Company.fromJson(action.company);
//   if (action is RemoveCompanyAction) return null;
//   return state;
// }

// CompanySettings settingsReducer(CompanySettings state, action) {
//   if (action is ChangeCompanySettingsAction)
//     return CompanySettings.fromJson(action.settings);
//   if (action is RemoveCompanySettingsAction) return null;
//   return state;
// }
