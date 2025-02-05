import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../providers/workout_provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  UserScreenState createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkoutProvider>(context, listen: false).fetchAllWorkouts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('In Progress Workouts')),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          if (!workoutProvider.isOnline) {
            return const Center(
              child: Text(
                'This section is only available online.',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          }

          if (workoutProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final inProgressWorkouts = workoutProvider.workouts
              .where((workout) => workout.status == "in progress")
              .toList();

          if (inProgressWorkouts.isEmpty) {
            return const Center(child: Text('No workouts in progress.'));
          }

          return ListView.builder(
            itemCount: inProgressWorkouts.length,
            itemBuilder: (context, index) {
              final workout = inProgressWorkouts[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(workout.name),
                  subtitle: Text(
                    'Duration: ${workout.duration} mins | Participants: ${workout.participants}',
                  ),
                  trailing: Text(workout.status),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
