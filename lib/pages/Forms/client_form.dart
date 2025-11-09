import 'package:flutter/material.dart';
import 'package:quote_builder/models/client_model.dart';

class AddClientPage extends StatefulWidget {
  const AddClientPage({super.key, required this.client});
  final Client client;

  @override
  State<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _referenceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client.name);
    _addressController = TextEditingController(text: widget.client.address);
    _referenceController = TextEditingController(text: widget.client.reference);
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedClient = Client(
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        reference: _referenceController.text.trim(),
      );

      Navigator.pop(context, updatedClient);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add/Update Client')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form( // ✅ Add Form widget here
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'Client Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter client name';
                  }
                  if (value.trim().isEmpty) {
                    return 'Client name cannot be just spaces';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  if (value.trim().isEmpty) {
                    return 'Address cannot be just spaces';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _referenceController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'Reference'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter reference';
                  }
                  if (value.trim().isEmpty) {
                    return 'Reference cannot be just spaces';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
