import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../providers/project_provider.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  AddProjectScreenState createState() => AddProjectScreenState();
}

class AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _teamController = TextEditingController();
  final _detailsController = TextEditingController();
  final _statusController = TextEditingController();
  final _membersController = TextEditingController();
  final _typeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _teamController.dispose();
    _detailsController.dispose();
    _statusController.dispose();
    _membersController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      try {
        final project = Project(
          id: -1,
          name: _nameController.text,
          team: _teamController.text,
          details: _detailsController.text,
          status: _statusController.text,
          members: int.parse(_membersController.text), // Ensure it's an integer
          type: _typeController.text,
        );

        Provider.of<ProjectProvider>(context, listen: false).addProject(project);
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Project added successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } catch (e) {
        _showSnackbar('Invalid number format for Members.');
      }
    } else {
      _showSnackbar('Please fill all fields correctly.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Project')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildTextField(_nameController, 'Project Name'),
              _buildTextField(_teamController, 'Team'),
              _buildTextField(_detailsController, 'Details'),
              _buildTextField(_statusController, 'Status'),
              _buildTextField(_membersController, 'Members', isNumber: true),
              _buildTextField(_typeController, 'Project Type'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add Project'),
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
