import '../../models/workout.dart';

enum WorkoutStatus {
  loading,
  success,
  empty,
  error,
}

enum WorkoutSort {
  name,
  duration,
  calories,
}

class WorkoutState {
  final WorkoutStatus status;
  final List<Workout> workouts;
  final Set<String> favoriteIds;
  final String searchQuery;
  final String category;
  final WorkoutSort sort;
  final bool favoritesOnly;
  final String? errorMessage;

  const WorkoutState({
    this.status = WorkoutStatus.loading,
    this.workouts = const [],
    this.favoriteIds = const {},
    this.searchQuery = '',
    this.category = 'all',
    this.sort = WorkoutSort.name,
    this.favoritesOnly = false,
    this.errorMessage,
  });
}