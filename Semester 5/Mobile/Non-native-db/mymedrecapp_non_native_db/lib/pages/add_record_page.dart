import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../repo/medical_record_repo.dart';
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
      appBar: AppBar(
        title: const Text("Add new record"),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            buildTextField(_titleController, "Title"),
            buildDropdown(_typeController, "Type",
                ["Appointment", "Lab Tests", "Medical Issues", "Other"]),
            buildTextField(
                _moneySpentController, "Money Spent", isNumber: true),
            buildDateField(context, "Select Date"),
            buildTextField(_detailsController, "Details", maxLines: 3),
            const SizedBox(height: 20),
            buildSaveButton(),
          ],
        ),
      ),
    );
  }

  TextFormField buildTextField(TextEditingController controller, String label,
      {int maxLines = 1, bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: isNumber ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      maxLines: maxLines,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter $label";
        }
        if (isNumber && double.tryParse(value) == null) {
          return "Please enter a valid number";
        }
        return null;
      },
    );
  }

  DropdownButtonFormField<String> buildDropdown(
      TextEditingController controller, String label, List<String> items) {
    return DropdownButtonFormField(
      value: controller.text.isEmpty ? null : controller.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: items.map((item) =>
          DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: (value) => setState(() => controller.text = value!),
      validator: (value) => value == null ? "Please select $label" : null,
    );
  }

  Widget buildDateField(BuildContext context, String label) {
    return ListTile(
      title: Text(_selectedDate == null ? label : DateFormat.yMd().format(
          _selectedDate!)),
      trailing: Icon(Icons.calendar_today),
      onTap: () => _selectDate(context),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Widget buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveRecord,
      child: Text("Save"),
    );
  }

  void _saveRecord() async {
    if (_formKey.currentState!.validate()) {
      final newRecord = MedicalRecord(
        title: _titleController.text,
        type: _typeController.text,
        moneySpent: double.tryParse(_moneySpentController.text) ?? 0,
        date: DateFormat('yyyy-MM-dd').format(_selectedDate ?? DateTime.now()),
        details: _detailsController.text,
      );

      try {
        await Provider.of<MedicalRecordRepository>(context, listen: false)
            .addRecord(newRecord);
        Navigator.pop(context, true); // Signal success and return to the previous page
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add record: $e")),
        );
      }
    }
  }
}
