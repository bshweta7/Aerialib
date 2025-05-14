// lib/presentation/cubit/navigation/nav_history_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class NavHistoryCubit extends Cubit<List<String>> {
  NavHistoryCubit() : super([]);

  /// Push a new route name onto the history stack (if not already last)
  void push(String routeName) {
    if (state.isEmpty || state.last != routeName) {
      final newState = List<String>.from(state);
      newState.add(routeName);
      print("[NavHistoryCubit] History $newState");
      emit(newState);
    }
  }

  /// Pop the most recent route from the history stack
  String? pop() {
    if (state.isEmpty) return null;
    final newState = List<String>.from(state);
    final last = newState.removeLast();
    emit(newState);
    return last;
  }

  /// Peek at the previous route (without removing it)
  String? peek() {
    if (state.isEmpty) return null;
    return state.last;
  }

  /// Clear the entire history (e.g., when going to a primary page)
  void clear() => emit([]);

  /// Replace the full stack (for restoration if needed)
  void setHistory(List<String> newHistory) => emit(List.from(newHistory));
}