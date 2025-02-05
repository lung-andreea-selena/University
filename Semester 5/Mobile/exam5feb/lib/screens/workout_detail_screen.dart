import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../providers/workout_provider.dart';
import 'edit_workout_screen.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final int workoutId;

  const WorkoutDetailScreen({super.key, required this.workoutId});

  @override
  WorkoutDetailScreenState createState() => WorkoutDetailScreenState();
}

class WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkoutProvider>(context, listen: false).fetchWorkoutById(widget.workoutId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Details')),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          if (workoutProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final workout = workoutProvider.selectedWorkout;
          if (workout == null) {
            return const Center(child: Text('Workout not found.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(workout.name, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                Text('Trainer: ${workout.trainer}'),
                Text('Status: ${workout.status}'),
                Text('Participants: ${workout.participants}'),
                Text('Duration: ${workout.duration} mins'),
                const SizedBox(height: 16),
                Text('Description:', style: Theme.of(context).textTheme.titleMedium),
                Text(workout.description),
                const SizedBox(height: 20),

                // Edit Workout Button (Only available when online)
                Consumer<WorkoutProvider>(
                  builder: (context, workoutProvider, child) {
                    return workoutProvider.isOnline
                        ? ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditWorkoutScreen(workout: workout),
                          ),
                        );
                      },
                      child: const Text('Edit Workout'),
                    )
                        : const Text(
                      'Editing is only available online.',
                      style: TextStyle(color: Colors.red),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
