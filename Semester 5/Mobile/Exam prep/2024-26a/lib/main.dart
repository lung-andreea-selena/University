import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/project_provider.dart';
import 'providers/websocket_provider.dart';
import 'screens/main_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/team_projects_screen.dart';
import 'screens/project_detail_screen.dart';
import 'screens/add_project_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProjectProvider()),
        ChangeNotifierProvider(create: (context) => WebSocketProvider()),
      ],
      child: MaterialApp(
        title: 'Project Management App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainScreen(),
        routes: {
          '/analytics': (context) => const AnalyticsScreen(),
          '/team-projects': (context) => const TeamProjectsScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/project-detail') {
            final int projectId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) => ProjectDetailScreen(projectId: projectId),
            );
          }
          return null;
        },
      ),
    );
  }
}
