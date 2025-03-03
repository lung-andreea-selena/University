import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repo/medical_record_repo.dart';
import '../models/medical_record.dart';

class MedicalRecordsListPage extends StatelessWidget {
  const MedicalRecordsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF198AB4),
      appBar: AppBar(
        title: const Text(
          "My Medical Records",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFD4F2F4),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<MedicalRecordRepository>(
        builder: (context, repo, child) {
          return ListView.builder(
            itemCount: repo.records.length,
            itemBuilder: (context, index) {
              final record = repo.records[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(record.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Date: ${record.date}"),
                      Text("Type: ${record.type}"),
                      Text("Details: ${record.details}"),
                      Text("Money Spent: \$${record.moneySpent.toStringAsFixed(2)}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editRecord(context, record),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteRecord(context, repo, record),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addRecord(context),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _editRecord(BuildContext context, MedicalRecord record) {
    Navigator.pushNamed(context, '/edit', arguments: record).then((updatedRecord) {
      if (updatedRecord != null) {
        context.read<MedicalRecordRepository>().updateRecord(updatedRecord as MedicalRecord);
      }
    });
  }

  void _deleteRecord(BuildContext context, MedicalRecordRepository repo, MedicalRecord record) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Record"),
          content: Text("Are you sure you want to delete '${record.title}'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                repo.deleteRecord(record.id!);
                Navigator.pop(context);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _addRecord(BuildContext context) {
    Navigator.pushNamed(context, '/add').then((newRecord) {
      if (newRecord != null) {
        context.read<MedicalRecordRepository>().addRecord(newRecord as MedicalRecord);
      }
    });
  }
}
