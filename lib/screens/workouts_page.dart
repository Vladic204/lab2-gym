import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/workout_cubit.dart';
import '../cubit/workout_state.dart';
import '../widgets/workout_card.dart';
import 'workout_details_page.dart';

class WorkoutsPage extends StatelessWidget {
  const WorkoutsPage({super.key});

  static const categories = {
    'all': 'All Type',
    'pilates': 'Pilates',
    'cardio': 'Cardio',
    'boxing': 'Boxing',
    'yoga': 'Yoga',
    'strength': 'Strength',
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutCubit, WorkoutState>(
      builder: (context, state) {
        final cubit = context.read<WorkoutCubit>();
        final ready = state.status == WorkoutStatus.success ||
            state.status == WorkoutStatus.empty;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Workout Programs'),
            actions: [
              IconButton(
                tooltip: state.favoritesOnly
                    ? 'Arată toate antrenamentele'
                    : 'Arată doar favoritele',
                onPressed: ready
                    ? cubit.toggleFavoritesOnly
                    : null,
                icon: Icon(
                  state.favoritesOnly
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: state.favoritesOnly ? Colors.red : null,
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    enabled: ready,
                    onChanged: cubit.search,
                    decoration: InputDecoration(
                      hintText: 'Caută un antrenament...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 52,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    children: categories.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(entry.value),
                          selected: state.category == entry.key,
                          onSelected: ready
                              ? (_) => cubit.filterByCategory(
                            entry.key,
                          )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const Text('Sortează după:'),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButton<WorkoutSort>(
                          value: state.sort,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                              value: WorkoutSort.name,
                              child: Text('Nume'),
                            ),
                            DropdownMenuItem(
                              value: WorkoutSort.duration,
                              child: Text('Durată'),
                            ),
                            DropdownMenuItem(
                              value: WorkoutSort.calories,
                              child: Text('Calorii'),
                            ),
                          ],
                          onChanged: ready
                              ? (value) {
                            if (value != null) {
                              cubit.changeSort(value);
                            }
                          }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildContent(context, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
      BuildContext context,
      WorkoutState state,
      ) {
    final cubit = context.read<WorkoutCubit>();

    switch (state.status) {
      case WorkoutStatus.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );

      case WorkoutStatus.empty:
        return const Center(
          child: Text('Nu există antrenamente pentru selecția ta.'),
        );

      case WorkoutStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.errorMessage ?? 'A apărut o eroare.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => cubit.loadWorkouts(),
                  child: const Text('Reîncearcă'),
                ),
              ],
            ),
          ),
        );

      case WorkoutStatus.success:
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.workouts.length,
          itemBuilder: (context, index) {
            final workout = state.workouts[index];

            return WorkoutCard(
              workout: workout,
              isFavorite: state.favoriteIds.contains(workout.id),
              onFavorite: () => cubit.toggleFavorite(workout.id),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkoutDetailsPage(
                      workout: workout,
                    ),
                  ),
                );
              },
            );
          },
        );
    }
  }
}