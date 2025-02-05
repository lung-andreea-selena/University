import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/workout_provider.dart';
import 'providers/websocket_provider.dart';
import 'screens/trainer_screen.dart';
import 'screens/user_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/workout_detail_screen.dart';
import 'screens/add_workout_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WorkoutProvider()),
        ChangeNotifierProvider(create: (context) => WebSocketProvider()),
      ],
      child: MaterialApp(
        title: 'Workout Tracking App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TrainerScreen(),
        routes: {
          '/user-section': (context) => const UserScreen(),
          '/analytics': (context) => const AnalyticsScreen(),
          '/add-workout': (context) => const AddWorkoutScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/workout-detail') {
            final int workoutId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) => WorkoutDetailScreen(workoutId: workoutId),
            );
          }
          return null;
        },
      ),
    );
  }
}
