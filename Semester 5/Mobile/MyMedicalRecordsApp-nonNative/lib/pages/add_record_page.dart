import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/mock_data.dart';
import '../models/medical_record.dart';

class AddRecordPage extends StatefulWidget {
  @override
  _AddRecordPageState createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _typeController = TextEditingController();
  final _moneySpentController = TextEditingController();
  final _detailsController = TextEditingController();

  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF198AB4),
      appBar: AppBar(
        title: const Text(
          "Add new record",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFD4F2F4),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFD4F2F4),
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a title";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Type Field
              DropdownButtonFormField<String>(
                value: null,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFD4F2F4),
                  labelText: "Type",
                  border: OutlineInputBorder(),
                ),
                items: ["Appointment", "Lab Tests", "Medical Issues", "Other"]
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  _typeController.text = value ?? "";
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select a type";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Money Spent Field
              TextFormField(
                controller: _moneySpentController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFD4F2F4),
                  labelText: "Money Spent",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the amount spent";
                  }
                  if (double.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Date Field
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4F2F4),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _selectedDate == null
                        ? "Select Date"
                        : DateFormat("yyyy-MM-dd").format(_selectedDate!),
                    style: TextStyle(
                      color: _selectedDate == null ? Colors.grey : Colors.black,backgroundColor: const Color(0xFFD4F2F4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Details Field
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFD4F2F4),
                  labelText: "Details",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Cancel the add operation
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4F2F4)),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please select a date")),
                          );
                          return;
                        }
                        final newRecord = MedicalRecord(
                          id: 111,
                          title: _titleController.text,
                          type: _typeController.text,
                          moneySpent: double.parse(_moneySpentController.text),
                          date: DateFormat("yyyy-MM-dd").format(_selectedDate!),
                          details: _detailsController.text,
                        );
                        MockData.records.add(newRecord);
                        Navigator.pop(context, true); // Signal success
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4F2F4)),
                    child: const Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to handle date selection
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
