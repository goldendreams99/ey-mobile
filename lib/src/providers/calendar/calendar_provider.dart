import 'package:employ/src/providers/calendar/calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarNotifier extends StateNotifier<CalendarState> {
  CalendarNotifier()
      : super(CalendarState(
          period: false,
        ));

  void setFrom(DateTime newValue) {
    DateTime date = DateTime(newValue.year, newValue.month, newValue.day);
    bool isEqual = state.from != null && state.from?.compareTo(newValue) == 0;

    state = state.copyWith(
      from: isEqual ? null : date,
      to: isEqual ? null : state.to,
    );
  }

  void setTo(DateTime? newValue) {
    if (newValue != null) {
      DateTime value = DateTime(newValue.year, newValue.month, newValue.day);
      bool isEqual = state.to != null && state.to?.compareTo(newValue) == 0;
      state = state.copyWith(to: isEqual ? null : value);
    } else {
      state = state.copyWith(to: null);
    }
  }

  void setPeriod(bool newValue) {
    state = state.copyWith(period: newValue);
  }

  bool isFrom(DateTime newValue) {
    DateTime time = DateTime(newValue.year, newValue.month, newValue.day);
    return state.from != null && time.compareTo(state.from!) == 0;
  }

  bool isTo(DateTime newValue) {
    DateTime time = DateTime(newValue.year, newValue.month, newValue.day);
    return state.to != null && time.compareTo(state.to!) == 0;
  }

  bool isToday(DateTime newValue) {
    DateTime _now = DateTime.now();
    DateTime time = DateTime(newValue.year, newValue.month, newValue.day);
    DateTime now = DateTime(_now.year, _now.month, _now.day);
    return (time.compareTo(now) == 0) && state.from == null;
  }

  bool isBetween(DateTime newValue) {
    DateTime time = DateTime(newValue.year, newValue.month, newValue.day);
    return state.from != null &&
        state.to != null &&
        (isTo(newValue) || time.isBefore(state.to!)) &&
        (isFrom(newValue) || time.isAfter(state.from!));
  }

  bool isSelected(DateTime newValue) {
    return isBetween(newValue) || isTo(newValue) || isFrom(newValue);
  }

  bool isOnly() {
    return (state.to != null && state.from == null) ||
        (state.from != null && state.to == null) ||
        (state.from != null &&
            state.to != null &&
            state.from!.compareTo(state.to!) == 0);
  }

  bool evaluate(DateTime current, DateTime newValue, [bool from = true]) {
    return from ? current.isAfter(newValue) : current.isBefore(newValue);
  }

  void select(DateTime newValue) {
    DateTime clicked = DateTime(newValue.year, newValue.month, newValue.day);
    if (state.period) {
      if (state.from == null ||
          (state.from != null && clicked.isBefore(state.from!))) {
        state = state.copyWith(from: clicked);
      } else if (state.from != null && state.to == null) {
        state = state.copyWith(to: clicked);
      } else if (state.from != null && state.to != null) {
        state = state.copyWith(from: clicked, to: null);
      }
    } else {
      state = state.copyWith(from: clicked);
    }
  }

  void init(DateTime from, [DateTime? to]) {
    state = state.copyWith(from: from, to: to);
  }
}

final calendarProvider = StateNotifierProvider<CalendarNotifier, CalendarState>(
  (ref) => CalendarNotifier(),
);
