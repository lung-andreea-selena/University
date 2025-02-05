import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../providers/workout_provider.dart';
import '../providers/websocket_provider.dart';
import 'add_workout_screen.dart';
import 'workout_detail_screen.dart';

class TrainerScreen extends StatefulWidget {
  const TrainerScreen({super.key});

  @override
  TrainerScreenState createState() => TrainerScreenState();
}

class TrainerScreenState extends State<TrainerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
      workoutProvider.fetchWorkouts();
      workoutProvider.syncOfflineWorkouts(); //sync offline workouts when online
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Trainer Workouts'),
            const SizedBox(width: 10),
            Consumer<WorkoutProvider>(
              builder: (context, workoutProvider, child) {
                return Icon(
                  workoutProvider.isOnline ? Icons.wifi : Icons.wifi_off,
                  color: workoutProvider.isOnline ? Colors.green : Colors.red,
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<WorkoutProvider>(context, listen: false).fetchWorkouts();
            },
          ),
          IconButton(
            icon: const Icon(Icons.supervised_user_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/user-section');
            },
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.pushNamed(context, '/analytics');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Consumer<WorkoutProvider>(
            builder: (context, workoutProvider, child) {
              if (workoutProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (workoutProvider.errorMessage != null && workoutProvider.workouts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(workoutProvider.errorMessage!),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          workoutProvider.fetchWorkouts();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              if (!workoutProvider.isLoading && !workoutProvider.isOnline) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You are offline. Showing local workouts.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                });
              }
              return ListView.builder(
                itemCount: workoutProvider.workouts.length,
                itemBuilder: (context, index) {
                  final workout = workoutProvider.workouts[index];
                  return WorkoutCard(workout: workout);
                },
              );
            },
          ),
          Consumer<WebSocketProvider>(
            builder: (context, webSocketProvider, child) {
              if (webSocketProvider.newWorkoutNotification != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final workout = webSocketProvider.newWorkoutNotification!;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Websocket: New workout added: ${workout.name} (${workout.trainer})'),
                      duration: const Duration(seconds: 4),
                    ),
                  );
                });
                return const SizedBox.shrink();
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddWorkoutScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final Workout workout;
  const WorkoutCard({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text('${workout.id}. ${workout.name}'),
        subtitle: Text('${workout.trainer} - ${workout.type}'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutDetailScreen(workoutId: workout.id),
            ),
          );
        },
      ),
    );
  }
}
