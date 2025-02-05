import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../providers/workout_provider.dart';

class EditWorkoutScreen extends StatefulWidget {
  final Workout workout;

  const EditWorkoutScreen({super.key, required this.workout});

  @override
  EditWorkoutScreenState createState() => EditWorkoutScreenState();
}

class EditWorkoutScreenState extends State<EditWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _trainerController;
  late TextEditingController _descriptionController;
  late TextEditingController _statusController;
  late TextEditingController _participantsController;
  late TextEditingController _typeController;
  late TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workout.name);
    _trainerController = TextEditingController(text: widget.workout.trainer);
    _descriptionController = TextEditingController(text: widget.workout.description);
    _statusController = TextEditingController(text: widget.workout.status);
    _participantsController = TextEditingController(text: widget.workout.participants.toString());
    _typeController = TextEditingController(text: widget.workout.type);
    _durationController = TextEditingController(text: widget.workout.duration.toString());
  }

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

  void _updateWorkout() {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedWorkout = Workout(
          id: widget.workout.id,
          name: _nameController.text,
          trainer: _trainerController.text,
          description: _descriptionController.text,
          status: _statusController.text,
          participants: int.parse(_participantsController.text),
          type: _typeController.text,
          duration: int.parse(_durationController.text),
        );

        Provider.of<WorkoutProvider>(context, listen: false).updateWorkout(updatedWorkout);
        Navigator.pop(context);

        _showSnackbar('Workout updated successfully!', Colors.green);
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
      appBar: AppBar(title: const Text('Edit Workout')),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          if (!workoutProvider.isOnline) {
            return const Center(
              child: Text(
                'Editing is only available online.',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildTextField(_nameController, 'Workout Name'),
                  _buildTextField(_trainerController, 'Trainer'),
                  _buildTextField(_descriptionController, 'Description'),
                  _buildTextField(_statusController, 'Status'),
                  _buildTextField(_participantsController, 'Participants', isNumber: true),
                  _buildTextField(_typeController, 'Workout Type'),
                  _buildTextField(_durationController, 'Duration (Minutes)', isNumber: true),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateWorkout,
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
          );
        },
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
