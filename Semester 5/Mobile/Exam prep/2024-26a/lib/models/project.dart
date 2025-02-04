import 'dart:convert';

class Project {
  final int id;
  final String name;
  final String team;
  final String details;
  final String status;
  late final int members;
  final String type;

  Project({
    required this.id,
    required this.name,
    required this.team,
    required this.details,
    required this.status,
    required this.members,
    required this.type,
  });

  // Convert JSON to Project object
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      team: json['team'],
      details: json['details'],
      status: json['status'],
      members: json['members'],
      type: json['type'],
    );
  }

  // Convert Project object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'team': team,
      'details': details,
      'status': status,
      'members': members,
      'type': type,
    };
  }
}
