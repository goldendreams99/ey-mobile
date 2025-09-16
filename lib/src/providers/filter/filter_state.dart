import 'package:copy_with_extension/copy_with_extension.dart';

part 'filter_state.g.dart';

@CopyWith()
class FilterState {
  final int year;

  final String state;
  //---------- BEGIN ----------//
  final String type;        // tipo seleccionado
  //---------- FINISH ----------//
  final List<int> years;
  final List<String> states;
  //---------- BEGIN ----------//
  final List<String> types; // tipos disponibles
  //---------- FINISH ----------//

  FilterState({
    required this.year,
    required this.state,
    //---------- BEGIN ----------//
    required this.type,
    //---------- FINISH ----------//
    required this.years,
    required this.states,
    //---------- BEGIN ----------//
    required this.types,
    //---------- FINISH ----------//
  });
}
