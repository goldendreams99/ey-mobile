// part of employ.config;

// class ViewModel {
//   final Employee employee;
//   final Company company;
//   final CompanySettings settings;
//   final Function(dynamic) onChangeCompany;
//   final Function(dynamic) onChangeEmployee;
//   final Function(dynamic) onChangeSettings;
//   final Function() onRemoveCompany;
//   final Function() onRemoveEmployee;
//   final Function() onRemoveSetting;

//   ViewModel({
//     this.employee,
//     this.company,
//     this.settings,
//     this.onChangeCompany,
//     this.onChangeEmployee,
//     this.onChangeSettings,
//     this.onRemoveCompany,
//     this.onRemoveEmployee,
//     this.onRemoveSetting,
//   });

//   factory ViewModel.create(Store<AppState> store) {
//     _onChangeEmployee(dynamic body) {
//       store.dispatch(ChangeEmployeeAction(body));
//     }

//     _onRemoveEmployee() {
//       store.dispatch(RemoveEmployeeAction());
//     }

//     _onChangeCompany(dynamic body) {
//       store.dispatch(ChangeCompanyAction(body));
//     }

//     _onRemoveCompany() {
//       store.dispatch(RemoveCompanyAction());
//     }

//     _onChangeSettings(dynamic body) {
//       store.dispatch(ChangeCompanySettingsAction(body));
//     }

//     _onRemoveSettings() {
//       store.dispatch(RemoveCompanySettingsAction());
//     }

//     return ViewModel(
//       employee: store.state.employee,
//       company: store.state.company,
//       settings: store.state.settings,
//       onChangeCompany: _onChangeCompany,
//       onChangeEmployee: _onChangeEmployee,
//       onChangeSettings: _onChangeSettings,
//       onRemoveCompany: _onRemoveCompany,
//       onRemoveEmployee: _onRemoveEmployee,
//       onRemoveSetting: _onRemoveSettings,
//     );
//   }
// }
