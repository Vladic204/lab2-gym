import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/workout.dart';
import '../repositories/workout_repository.dart';
import 'workout_state.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  final WorkoutRepository repository;

  List<Workout> _allWorkouts = [];
  final Set<String> _favoriteIds = {};

  String _searchQuery = '';
  String _category = 'all';
  WorkoutSort _sort = WorkoutSort.name;
  bool _favoritesOnly = false;
  bool _loaded = false;

  WorkoutCubit(this.repository) : super(const WorkoutState());

  Future<void> loadWorkouts() async {
    if (state.status == WorkoutStatus.loading && _loading) return;

    _loading = true;
    _loaded = false;
    _emitState(WorkoutStatus.loading);

    try {
      final workouts = await repository.loadWorkouts();

      if (isClosed) return;

      _allWorkouts = workouts;
      _loaded = true;
      _applyFilters();
    } catch (error) {
      if (isClosed) return;

      _emitState(
        WorkoutStatus.error,
        errorMessage: 'Nu s-au putut încărca antrenamentele: $error',
      );
    } finally {
      _loading = false;
    }
  }

  bool _loading = false;

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByCategory(String category) {
    _category = category;
    _applyFilters();
  }

  void changeSort(WorkoutSort sort) {
    _sort = sort;
    _applyFilters();
  }

  void toggleFavorite(String id) {
    if (!_favoriteIds.add(id)) {
      _favoriteIds.remove(id);
    }

    _applyFilters();
  }

  void toggleFavoritesOnly() {
    _favoritesOnly = !_favoritesOnly;
    _applyFilters();
  }

  void _applyFilters() {
    if (!_loaded || isClosed) return;

    final query = _searchQuery.trim().toLowerCase();

    final filtered = _allWorkouts.where((workout) {
      final matchesSearch =
      workout.title.toLowerCase().contains(query);

      final matchesCategory =
          _category == 'all' || workout.category == _category;

      final matchesFavorites =
          !_favoritesOnly || _favoriteIds.contains(workout.id);

      return matchesSearch && matchesCategory && matchesFavorites;
    }).toList();

    filtered.sort((a, b) {
      switch (_sort) {
        case WorkoutSort.name:
          return a.title.compareTo(b.title);

        case WorkoutSort.duration:
          return a.durationMinutes.compareTo(b.durationMinutes);

        case WorkoutSort.calories:
          return a.calories.compareTo(b.calories);
      }
    });

    _emitState(
      filtered.isEmpty
          ? WorkoutStatus.empty
          : WorkoutStatus.success,
      workouts: filtered,
    );
  }

  void _emitState(
      WorkoutStatus status, {
        List<Workout> workouts = const [],
        String? errorMessage,
      }) {
    if (isClosed) return;

    emit(
      WorkoutState(
        status: status,
        workouts: List<Workout>.unmodifiable(workouts),
        favoriteIds: Set<String>.unmodifiable(_favoriteIds),
        searchQuery: _searchQuery,
        category: _category,
        sort: _sort,
        favoritesOnly: _favoritesOnly,
        errorMessage: errorMessage,
      ),
    );
  }
}