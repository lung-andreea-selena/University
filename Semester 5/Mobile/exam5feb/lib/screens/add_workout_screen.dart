import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../providers/workout_provider.dart';

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  AddWorkoutScreenState createState() => AddWorkoutScreenState();
}

class AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _trainerController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _statusController = TextEditingController();
  final _participantsController = TextEditingController();
  final _typeController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _trainerController.dispose();
    _descriptionController.dispose();
    _statusController.dispose();
    _participantsController.dispose();
    _typeController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      try {
        final workout = Workout(
          id: -1, // temporary ID
          name: _nameController.text,
          trainer: _trainerController.text,
          description: _descriptionController.text,
          status: _statusController.text,
          participants: int.parse(_participantsController.text),
          type: _typeController.text,
          duration: int.parse(_durationController.text),
        );

        Provider.of<WorkoutProvider>(context, listen: false).addWorkout(workout);
        Navigator.pop(context);

        _showSnackbar('Workout added successfully!', Colors.green);
      } catch (e) {
        _showSnackbar('Invalid number format for Participants or Duration.', Colors.red);
      }
    } else {
      _showSnackbar('Please fill all fields correctly.', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Workout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildTextField(_nameController, 'Workout Name'),
              _buildTextField(_trainerController, 'Trainer'),
              _buildTextField(_descriptionController, 'Description'),
              _buildTextField(_statusController, 'Status'),
              _buildTextField(_participantsController, 'Participants', isNumber: true),
              _buildTextField(_typeController, 'Workout Type'),
              _buildTextField(_durationController, 'Duration (Minutes)', isNumber: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        if (isNumber && int.tryParse(value) == null) {
          return 'Enter a valid number for $label';
        }
        return null;
      },
    );
  }
}
