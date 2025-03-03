import 'package:flutter/material.dart';
import '../models/medical_record.dart';

class EditRecordPage extends StatefulWidget {
  final MedicalRecord record;

  const EditRecordPage({Key? key, required this.record}) : super(key: key);

  @override
  State<EditRecordPage> createState() => _EditRecordPageState();
}

class _EditRecordPageState extends State<EditRecordPage> {
  late TextEditingController titleController;
  late TextEditingController moneySpentController;
  late TextEditingController dateController;
  late TextEditingController detailsController;
  late String selectedType;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing record data
    titleController = TextEditingController(text: widget.record.title);
    moneySpentController =
        TextEditingController(text: widget.record.moneySpent.toString());
    dateController = TextEditingController(text: widget.record.date);
    detailsController = TextEditingController(text: widget.record.details);

    // Ensure the selectedType matches one of the predefined types
    selectedType = [
      'Appointment',
      'Lab tests',
      'Medical issues',
      'Other',
    ].contains(widget.record.type.trim())
        ? widget.record.type.trim()
        : 'Other';
  }

  @override
  void dispose() {
    // Dispose of controllers
    titleController.dispose();
    moneySpentController.dispose();
    dateController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF198AB4),
      appBar: AppBar(
        title: const Text(
          "Edit medical record",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFD4F2F4), // Match AppBar color
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title Field
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD4F2F4),
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Title is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Date Picker Field
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD4F2F4),
                labelText: "Date",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    dateController.text =
                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Type Dropdown
            DropdownButtonFormField<String>(
              value: selectedType,
              items: [
                'Appointment',
                'Lab tests',
                'Medical issues',
                'Other',
              ].map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
              decoration: const InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD4F2F4),
                labelText: "Type",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Money Spent Field
            TextFormField(
              controller: moneySpentController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD4F2F4),
                labelText: "Money Spent",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Money spent is required";
                }
                if (double.tryParse(value) == null) {
                  return "Enter a valid number";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Details Field
            TextFormField(
              controller: detailsController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD4F2F4),
                labelText: "Details",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),

            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cancel and go back
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4F2F4)),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_validateForm()) {
                      Navigator.pop(
                        context,
                        MedicalRecord(
                          id: widget.record.id,
                          title: titleController.text,
                          type: selectedType,
                          moneySpent:
                              double.tryParse(moneySpentController.text) ?? 0.0,
                          date: dateController.text,
                          details: detailsController.text,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4F2F4)),
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _validateForm() {
    if (titleController.text.isEmpty) {
      _showError("Title is required");
      return false;
    }
    if (moneySpentController.text.isEmpty ||
        double.tryParse(moneySpentController.text) == null) {
      _showError("Valid money spent is required");
      return false;
    }
    if (dateController.text.isEmpty) {
      _showError("Date is required");
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
