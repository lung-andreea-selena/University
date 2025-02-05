import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../providers/workout_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  AnalyticsScreenState createState() => AnalyticsScreenState();
}

class AnalyticsScreenState extends State<AnalyticsScreen> {
  List<Workout> topWorkouts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTopWorkouts();
    });
  }

  Future<void> _loadTopWorkouts() async {
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    await workoutProvider.fetchAllWorkouts();

    final workouts = workoutProvider.workouts;
    if (workouts.isNotEmpty) {
      topWorkouts = _calculateTopWorkouts(workouts);
      setState(() {});
    }
  }


  List<Workout> _calculateTopWorkouts(List<Workout> workouts) {
    List<Workout> sortedWorkouts = workouts.toList();
    sortedWorkouts.sort((a, b) {
      int statusComparison = a.status.compareTo(b.status);
      if (statusComparison != 0) return statusComparison;
      return b.participants.compareTo(a.participants);
    });
    return sortedWorkouts.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top 5 Workouts by Participants')),
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

          if (workoutProvider.isLoading && topWorkouts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (topWorkouts.isEmpty) {
            return const Center(child: Text('No data available.'));
          }

          return ListView.builder(
            itemCount: topWorkouts.length,
            itemBuilder: (context, index) {
              final workout = topWorkouts[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(workout.name),
                  subtitle: Text(
                    'Status: ${workout.status} | Participants: ${workout.participants}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
