import 'package:flutter/material.dart';
import 'package:medrecord_frontend/pages/add_record_page.dart';
import 'package:medrecord_frontend/pages/edit_record_page.dart';
import 'package:medrecord_frontend/pages/medical_record_list.dart';
import 'package:medrecord_frontend/repo/medical_record_repo.dart';
import 'package:provider/provider.dart';

import 'models/medical_record.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MedicalRecordRepository>(
        create: (_) => MedicalRecordRepository(),
        child: MaterialApp(
          title: 'Medical Records App',
          theme: ThemeData(
            primarySwatch: Colors.teal,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const MedicalRecordsListPage(),
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/add':
                return MaterialPageRoute(
                  builder: (context) => AddRecordPage(),
                );
              case '/edit':
              // Ensure that settings.arguments is the record you expect to edit.
                if (settings.arguments is MedicalRecord) {
                  return MaterialPageRoute(
                    builder: (context) =>
                        EditRecordPage(
                            record: settings.arguments as MedicalRecord),
                  );
                }
                // Consider adding error handling for unexpected arguments.
                break;
              default:
                return MaterialPageRoute(
                    builder: (context) => const MedicalRecordsListPage());
            }
            return null;
          },
        )
    );
  }
}