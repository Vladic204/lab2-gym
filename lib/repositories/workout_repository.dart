import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/workout.dart';

class WorkoutRepository {
  Future<List<Workout>> loadWorkouts() async {
    final jsonText = await rootBundle.loadString(
      'assets/data/fitness.json',
    );

    final data = jsonDecode(jsonText) as Map<String, dynamic>;

    final items = data['fitnessHomePage']['workoutPrograms']['items']
    as List<dynamic>;

    return items
        .map(
          (item) => Workout.fromJson(
        item as Map<String, dynamic>,
      ),
    )
        .toList();
  }
}