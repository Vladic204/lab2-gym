import 'package:flutter/material.dart';

import '../models/workout.dart';

class WorkoutDetailsPage extends StatelessWidget {
  final Workout workout;

  const WorkoutDetailsPage({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              workout.imageUrl,
              height: 280,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;

                return const SizedBox(
                  height: 280,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 280,
                  child: Center(
                    child: Icon(
                      Icons.fitness_center,
                      size: 64,
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                    ),
                    title: const Text('Calorii'),
                    subtitle: Text('${workout.calories} kcal'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.access_time),
                    title: const Text('Durată'),
                    subtitle: Text(
                      '${workout.durationMinutes} minute',
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.category),
                    title: const Text('Categorie'),
                    subtitle: Text(workout.category),
                  ),
                  const SizedBox(height: 16),
                  Chip(
                    avatar: Icon(
                      workout.isPro
                          ? Icons.workspace_premium
                          : Icons.check_circle_outline,
                    ),
                    label: Text(
                      workout.isPro
                          ? 'Antrenament PRO'
                          : 'Antrenament standard',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}