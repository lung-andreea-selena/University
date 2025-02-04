import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../providers/project_provider.dart';

class TeamProjectsScreen extends StatefulWidget {
  const TeamProjectsScreen({super.key});

  @override
  TeamProjectsScreenState createState() => TeamProjectsScreenState();
}

class TeamProjectsScreenState extends State<TeamProjectsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProjectProvider>(context, listen: false).fetchProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('In Progress Projects')),
      body: Consumer<ProjectProvider>(
        builder: (context, projectProvider, child) {
          if (projectProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (projectProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(projectProvider.errorMessage!),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      projectProvider.fetchProjects();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          final inProgressProjects = projectProvider.projects
              .where((project) => project.status == "in progress")
              .toList();
          if (inProgressProjects.isEmpty) {
            return const Center(child: Text('No projects in progress.'));
          }
          return ListView.builder(
            itemCount: inProgressProjects.length,
            itemBuilder: (context, index) {
              final project = inProgressProjects[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(project.name),
                  subtitle: Text('${project.team} - ${project.type}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Provider.of<ProjectProvider>(context, listen: false)
                          .enrollInProject(project.id);
                    },
                    child: const Text('Enroll'),
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
