import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/medical_record.dart';

class MedicalRecordsListPage extends StatefulWidget {
  @override
  State<MedicalRecordsListPage> createState() => _MedicalRecordsListPageState();
}

class _MedicalRecordsListPageState extends State<MedicalRecordsListPage> {
  @override
  Widget build(BuildContext context) {
    final records = MockData.records;

    return Scaffold(
      backgroundColor: const Color(0xFF198AB4), // Background color
      appBar: AppBar(
        title: const Text(
          "My Medical Records",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFD4F2F4), // Match AppBar color
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Add padding like in XML
        child: ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10), // Space between cards
              color: const Color(0xFFD4F2F4), // Card background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0), // Inner padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.title,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${record.date}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${record.type}",
                      style: const TextStyle(
                          fontSize: 17,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "\$${record.moneySpent.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${record.details}",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.black),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/edit',
                              arguments: record,
                            ).then((updatedRecord) {
                              if (updatedRecord != null &&
                                  updatedRecord is MedicalRecord) {
                                // Update the record in MockData.records
                                final int index = MockData.records.indexWhere(
                                    (r) => r.id == updatedRecord.id);
                                if (index != -1) {
                                  setState(() {
                                    MockData.records[index] = updatedRecord;
                                  });
                                }
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.black),
                          onPressed: () {
                            _showDeleteConfirmation(context, record);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bool? result =
              await Navigator.pushNamed(context, '/add') as bool?;
          if (result == true) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showDeleteConfirmation(BuildContext context, MedicalRecord record) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Record"),
          content: Text("Are you sure you want to delete '${record.title}'?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteRecord(record);
                Navigator.pop(context); // Close the dialog
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteRecord(MedicalRecord record) {
    setState(() {
      MockData.records.remove(record); // Remove the record from mock data
    });
  }
}
