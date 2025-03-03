import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/medical_record.dart';
import '../repo/medical_record_repo.dart';

class EditRecordPage extends StatefulWidget {
  final MedicalRecord record;

  const EditRecordPage({Key? key, required this.record}) : super(key: key);

  @override
  State<EditRecordPage> createState() => _EditRecordPageState();
}

class _EditRecordPageState extends State<EditRecordPage> {
  late TextEditingController titleController;
  late TextEditingController moneySpentController;
  late TextEditingController detailsController;
  late TextEditingController dateController;
  late String selectedType;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.record.title);
    moneySpentController = TextEditingController(text: widget.record.moneySpent.toString());
    detailsController = TextEditingController(text: widget.record.details);
    selectedType = widget.record.type;
    dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.record.date)));
  }

  @override
  void dispose() {
    titleController.dispose();
    moneySpentController.dispose();
    detailsController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<MedicalRecordRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Medical Record"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildTextField(titleController, 'Title'),
              buildTextField(moneySpentController, 'Money Spent', isNumber: true),
              DropdownButtonFormField<String>(
                value: selectedType,
                onChanged: (newValue) {
                  setState(() {
                    selectedType = newValue!;
                  });
                },
                items: ['Appointment', 'Lab Tests', 'Medical Issues', 'Other']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              buildTextField(detailsController, 'Details', maxLines: 3),
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(dateController.text),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_validateForm()) {
                    final updatedRecord = MedicalRecord(
                      id: widget.record.id,
                      title: titleController.text,
                      type: selectedType,
                      date: dateController.text,
                      details: detailsController.text,
                      moneySpent: double.tryParse(moneySpentController.text) ?? 0,
                    );
                    try {
                      await repo.updateRecord(updatedRecord);
                      Navigator.pop(context, true);
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Update failed: $e')));
                    }
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label, {int maxLines = 1, bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label cannot be empty";
        }
        if (isNumber && double.tryParse(value) == null) {
          return "Please enter a valid number for $label";
        }
        return null;
      },
    );
  }

  bool _validateForm() {
    bool isValid = titleController.text.isNotEmpty &&
        moneySpentController.text.isNotEmpty &&
        double.tryParse(moneySpentController.text) != null &&
        detailsController.text.isNotEmpty &&
        dateController.text.isNotEmpty;

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields correctly"),
          backgroundColor: Colors.red,
        ),
      );
    }
    return isValid;
  }
}
