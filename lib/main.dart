import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/workout_cubit.dart';
import 'repositories/workout_repository.dart';
import 'screens/workouts_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF20C766),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
      ),
      home: BlocProvider(
        create: (_) => WorkoutCubit(
          WorkoutRepository(),
        )..loadWorkouts(),
        child: const WorkoutsPage(),
      ),
    );
  }
}