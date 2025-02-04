import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../providers/project_provider.dart';
import '../providers/websocket_provider.dart';
import 'add_project_screen.dart';
import 'project_detail_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      projectProvider.fetchProjects();
      projectProvider.syncOfflineProjects(); // Sync offline projects when online
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.explore),
            onPressed: () {
              Navigator.pushNamed(context, '/team-projects');
            },
          ),
          IconButton(
            icon: const Icon(Icons.insights),
            onPressed: () {
              Navigator.pushNamed(context, '/analytics');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Consumer<ProjectProvider>(
            builder: (context, projectProvider, child) {
              if (projectProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (projectProvider.errorMessage != null && projectProvider.projects.isEmpty) {
                // Only show Retry UI if there are NO local projects
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

              if (!projectProvider.isLoading && !projectProvider.isOnline) {
                // Show Snackbar only if offline, but we still have local data
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You are offline. Showing local projects.'),
                      duration: Duration(seconds: 10),
                    ),
                  );
                });
              }

              return ListView.builder(
                itemCount: projectProvider.projects.length,
                itemBuilder: (context, index) {
                  final project = projectProvider.projects[index];
                  return ProjectCard(project: project);
                },
              );
            },
          ),
          Consumer<WebSocketProvider>(
            builder: (context, webSocketProvider, child) {
              if (webSocketProvider.newProjectNotification != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final project = webSocketProvider.newProjectNotification!;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Websocket: New project added: ${project.name} (${project.team})'),
                      duration: const Duration(seconds: 3),
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
            MaterialPageRoute(builder: (context) => const AddProjectScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final Project project;
  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(project.name),
        subtitle: Text('${project.team} - ${project.type}'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectDetailScreen(projectId: project.id),
            ),
          );
        },
      ),
    );
  }
}
