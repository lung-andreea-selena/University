import 'package:flutter/material.dart';
import '../models/project.dart';
import '../services/api_service.dart';
import '../services/db_helper.dart';

class ProjectProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Project> _projects = [];
  Project? _selectedProject;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isOnline = true; // Default to true, assumes online initially.

  List<Project> get projects => _projects;
  Project? get selectedProject => _selectedProject;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isOnline => _isOnline;

  Future<void> fetchProjects() async {
    _setLoading(true);
    _clearErrorMessage();

    try {
      final fetchedProjects = await _apiService.fetchAllProjects();
      _projects = fetchedProjects;
      await _dbHelper.clearDatabase(); // Clear old data before storing new data
      for (var project in fetchedProjects) {
        await _dbHelper.insertProject(project);
      }
      _isOnline = true; // Server responded, so we are online
    } catch (e) {
      // Only set the error if local data is also empty
      _projects = await _dbHelper.getProjects();
      if (_projects.isEmpty) {
        _setErrorMessage('No internet connection. Please try again.');
      } else {
        _isOnline = false; // Set offline mode, but don't display error
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addProject(Project project) async {
    _setLoading(true);
    _clearErrorMessage();

    try {
      if (_isOnline) {
        final newProject = await _apiService.addProject(project);
        _projects.add(newProject);
        await _dbHelper.insertProject(newProject);
      } else {
        await _dbHelper.insertProject(project); // Save locally
        _projects.add(project);
      }
      notifyListeners();
    } catch (e) {
      _setErrorMessage('Failed to add project.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchProjectById(int id) async {
    _setLoading(true);
    _clearErrorMessage();
    _selectedProject = null; // Clear previous selection

    try {
      final project = await _apiService.fetchProjectById(id);
      _selectedProject = project;
      await _dbHelper.insertProject(project!); // Store in local DB for offline access
      _isOnline = true; // We are online
    } catch (e) {
      _setErrorMessage('Failed to fetch project details. Displaying offline data.');
      _selectedProject = await _dbHelper.getProjectById(id); // Load from local DB if offline
      _isOnline = false; // We are offline
    } finally {
      _setLoading(false);
    }
  }

  Future<void> enrollInProject(int id) async {
    _setLoading(true);
    _clearErrorMessage();

    try {
      final updatedProject = await _apiService.enrollInProject(id);
      int index = _projects.indexWhere((p) => p.id == id);
      if (index != -1) {
        _projects[index] = updatedProject; // Update project in memory
        await _dbHelper.updateProject(updatedProject); // Sync with local DB
      }
      notifyListeners();
    } catch (e) {
      _setErrorMessage('Failed to enroll in the project.');
    } finally {
      _setLoading(false);
    }
  }




  Future<void> syncOfflineProjects() async {
    List<Project> offlineProjects = await _dbHelper.getProjects();
    for (var project in offlineProjects) {
      if (project.id == -1) { // Newly created offline projects
        await addProject(project); // Attempt to sync
      }
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
