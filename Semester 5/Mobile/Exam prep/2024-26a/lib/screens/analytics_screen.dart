import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../providers/project_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  AnalyticsScreenState createState() => AnalyticsScreenState();
}

class AnalyticsScreenState extends State<AnalyticsScreen> {
  List<Project> topProjects = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTopProjects();
    });
  }

  Future<void> _loadTopProjects() async {
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    await projectProvider.fetchProjects();

    final projects = projectProvider.projects;
    if (projects.isNotEmpty) {
      topProjects = _calculateTopProjects(projects);
      setState(() {});
    }
  }


  List<Project> _calculateTopProjects(List<Project> projects) {
    List<Project> sortedProjects = projects.toList();
    sortedProjects.sort((a, b) {
      int statusComparison = a.status.compareTo(b.status);
      if (statusComparison != 0) return statusComparison;
      return b.members.compareTo(a.members);
    });
    return sortedProjects.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top 5 Projects by Members')),
      body: Consumer<ProjectProvider>(
        builder: (context, projectProvider, child) {
          if (projectProvider.isLoading && topProjects.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (topProjects.isEmpty) {
            return const Center(child: Text('No projects available.'));
          }
          return ListView.builder(
            itemCount: topProjects.length,
            itemBuilder: (context, index) {
              final project = topProjects[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(project.name),
                  subtitle:
                  Text('Status: ${project.status} | Members: ${project.members}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
