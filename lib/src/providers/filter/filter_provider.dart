import 'package:employ/src/providers/filter/filter_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier()
      : super(FilterState(
          state: 'Pendientes',
          states: [],
          year: DateTime.now().year,
          years: [],
          //---------- BEGIN ----------//
          type: 'Todos',
          types: [],
          //---------- FINISH ----------//
        ));

  setYear(int newValue) {
    state = state.copyWith(year: newValue);
  }

  setState(String newValue) {
    state = state.copyWith(state: newValue);
  }

  //---------- BEGIN ----------//
  setType(String newValue) {
    state = state.copyWith(type: newValue);
  }
  //---------- FINISH ----------//

  setYears(List<int> newValue) {
    state = state.copyWith(years: newValue);
  }

  setStates(List<String> newValue) {
    state = state.copyWith(states: newValue);
  }

  //---------- BEGIN ----------//
  setTypes(List<String> newValue) {
    state = state.copyWith(types: newValue);
  }
  //---------- FINISH ----------//
}

final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>(
  (ref) => FilterNotifier(),
);
