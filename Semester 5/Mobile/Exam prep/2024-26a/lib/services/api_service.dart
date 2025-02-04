import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project.dart';

const String serverUrl = 'http://192.168.1.132:2426';

class ApiService {
  Future<List<Project>> fetchAllProjects() async {
    final response = await http.get(Uri.parse('$serverUrl/projects'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Project.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Future<Project?> fetchProjectById(int id) async {
    final response = await http.get(Uri.parse('$serverUrl/project/$id'));

    if (response.statusCode == 200) {
      return Project.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<Project> addProject(Project project) async {
    final response = await http.post(
      Uri.parse('$serverUrl/project'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(project.toJson()..remove('id')), // Server assigns ID
    );

    if (response.statusCode == 200) {
      return Project.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add project');
    }
  }

  Future<Project> enrollInProject(int id) async {
    final response = await http.put(Uri.parse('$serverUrl/enroll/$id'));

    print('Enroll API Response: ${response.body}'); // Debugging

    if (response.statusCode == 200) {
      return Project.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to enroll in project (Status: ${response.statusCode})');
    }
  }



  Future<List<Project>> fetchInProgressProjects() async {
    final response = await http.get(Uri.parse('$serverUrl/inProgress'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Project.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load in-progress projects');
    }
  }
}
