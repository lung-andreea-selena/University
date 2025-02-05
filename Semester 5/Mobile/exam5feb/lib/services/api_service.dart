import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/workout.dart';

const String serverUrl = 'http://172.30.252.67:2505';

class ApiService {
  Future<List<Workout>> fetchAllWorkouts() async {
    final response = await http.get(Uri.parse('$serverUrl/workouts'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Workout.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load workouts');
    }
  }

  Future<Workout?> fetchWorkoutById(int id) async {
    final response = await http.get(Uri.parse('$serverUrl/workout/$id'));

    if (response.statusCode == 200) {
      return Workout.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<Workout> addWorkout(Workout workout) async {
    final response = await http.post(
      Uri.parse('$serverUrl/workout'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(workout.toJson()..remove('id')), // Don't send ID for new workouts
    );

    if (response.statusCode == 200) {
      return Workout.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add workout');
    }
  }

  Future<Workout> updateWorkout(Workout workout) async {
    final response = await http.put(
      Uri.parse('$serverUrl/workout'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(workout.toJson()),
    );

    if (response.statusCode == 200) {
      return Workout.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update workout');
    }
  }

  Future<List<Workout>> fetchInProgressWorkouts() async {
    final response = await http.get(Uri.parse('$serverUrl/allWorkouts'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Workout.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load in-progress workouts');
    }
  }
}
