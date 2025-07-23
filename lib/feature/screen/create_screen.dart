import 'package:flutter/material.dart';
import 'package:sm_t/core/models/network_response.dart';
import 'package:sm_t/core/services/network_caller.dart';
import 'package:sm_t/core/utils/urls.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  bool _isSaving = false;

  Future<void> _createData() async {
    final String name = _nameController.text.trim();
    final String color = _colorController.text.trim();
    final String capacity = _capacityController.text.trim();

    if (name.isEmpty || color.isEmpty || capacity.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.getAllData,
      body: {
        "name": name,
        "data": {
          "color": color,
          "capacity": capacity,
        }
      },
    );

    setState(() {
      _isSaving = false;
    });

    if (response.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data created successfully")),
      );
      Navigator.pop(context, true); // true means success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create data: ${response.errorMassage}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Data")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isSaving
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _colorController,
              decoration: const InputDecoration(labelText: "Color"),
            ),
            TextField(
              controller: _capacityController,
              decoration: const InputDecoration(labelText: "Capacity"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _createData,
              icon: const Icon(Icons.add),
              label: const Text("Create"),
            )
          ],
        ),
      ),
    );
  }
}
