import 'package:flutter/material.dart';
import 'models/medical_record.dart';
import 'pages/medical_records_list.dart';
import 'pages/add_record_page.dart';
import 'pages/edit_record_page.dart';
// Import the add and edit pages when ready

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Medical Records',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (context) => MedicalRecordsListPage(),
        '/add': (context) => AddRecordPage(),
        '/edit': (context) => EditRecordPage(record: ModalRoute.of(context)!.settings.arguments as MedicalRecord),
      },
    );
  }
}
