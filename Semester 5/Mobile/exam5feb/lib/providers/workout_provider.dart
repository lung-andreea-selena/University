import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../services/api_service.dart';
import '../services/db_helper.dart';

class WorkoutProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Workout> _workouts = [];
  Workout? _selectedWorkout;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isOnline = true; // assume online

  List<Workout> get workouts => _workouts;
  Workout? get selectedWorkout => _selectedWorkout;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isOnline => _isOnline;

  Future<void> fetchWorkouts() async {
    _setLoading(true);
    _clearErrorMessage();

    try {
      final fetchedWorkouts = await _apiService.fetchAllWorkouts();
      _workouts = fetchedWorkouts;

      await _dbHelper.clearDatabase();
      for (var workout in fetchedWorkouts) {
        await _dbHelper.insertWorkout(workout);
      }
      _isOnline = true;//server responded => we are online
      await syncOfflineWorkouts();
    } catch (e) {
      _workouts = await _dbHelper.getWorkouts();
      if (_workouts.isEmpty) {
        _setErrorMessage('No internet connection');
      } else {
        _isOnline = false; //set offline mode
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchAllWorkouts() async {
    _setLoading(true);
    _clearErrorMessage();

    try {
      final fetchedWorkouts = await _apiService.fetchInProgressWorkouts();
      _workouts = fetchedWorkouts;

      await _dbHelper.clearDatabase();
      for (var workout in fetchedWorkouts) {
        await _dbHelper.insertWorkout(workout);
      }
    } catch (e) {
        _setErrorMessage('No internet connection');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchWorkoutById(int id) async {
    _setLoading(true);
    _clearErrorMessage();
    _selectedWorkout = null;

    try {
      _selectedWorkout = await _apiService.fetchWorkoutById(id);
      if (_selectedWorkout != null) {
        await _dbHelper.insertWorkout(_selectedWorkout!);//store in local db for offline access
        _isOnline = true;
      }
    } catch (e) {
      _setErrorMessage('Failed to fetch workout details. Displaying offline data.');
      _selectedWorkout = await _dbHelper.getWorkoutById(id);
      if (_selectedWorkout == null) {
        _setErrorMessage('Workout not found.');
      }
      _isOnline = false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addWorkout(Workout workout) async {
    _setLoading(true);
    _clearErrorMessage();

    try {
      if (_isOnline) {
        final newWorkout = await _apiService.addWorkout(workout);
        _workouts.add(newWorkout);
        await _dbHelper.insertWorkout(newWorkout);
      } else {
        await _dbHelper.insertWorkout(workout);
        _workouts.add(workout);
      }
      notifyListeners();
    } catch (e) {
      _setErrorMessage('Failed to add workout.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateWorkout(Workout workout) async {
    _setLoading(true);
    _clearErrorMessage();

    try {
      final updatedWorkout = await _apiService.updateWorkout(workout);
      int index = _workouts.indexWhere((w) => w.id == workout.id);
      if (index != -1) {
        _workouts[index] = updatedWorkout;
        await _dbHelper.updateWorkout(updatedWorkout);
      }
      notifyListeners();
    } catch (e) {
      _setErrorMessage('Failed to update workout.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> syncOfflineWorkouts() async {
    _setLoading(true);
    try {
      List<Workout> offlineWorkouts = await _dbHelper.getWorkouts();

      for (var workout in offlineWorkouts) {
        if (workout.id == -1) {
          final newWorkout = await _apiService.addWorkout(workout);

          await _dbHelper.deleteWorkout(workout.id);
          await _dbHelper.insertWorkout(newWorkout);
        }
      }

      notifyListeners();
    } catch (e) {
      _setErrorMessage('Failed to sync offline workouts.');
    } finally {
      _setLoading(false);
    }
  }


  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}
