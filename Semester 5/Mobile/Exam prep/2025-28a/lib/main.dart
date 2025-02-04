import 'package:exam_prep/providers/recipe_provider.dart';
import 'package:exam_prep/providers/websocket_provider.dart';
import 'package:exam_prep/screens/explore_screen.dart';
import 'package:exam_prep/screens/insights_screen.dart';
import 'package:exam_prep/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RecipeProvider()),
        ChangeNotifierProvider(create: (context) => WebSocketProvider()),
      ],
      child: MaterialApp(
        title: 'Recipe Sharing App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainScreen(),
        routes: {
          '/explore': (context) => const ExploreScreen(),
          '/insights': (context) => const InsightsScreen(),
        },
      ),
    );
  }
}