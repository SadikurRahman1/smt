import 'package:flutter/material.dart';
import 'package:sm_t/core/models/data_model.dart';
import 'package:sm_t/core/models/network_response.dart';
import 'package:sm_t/core/services/network_caller.dart';
import 'package:sm_t/core/utils/urls.dart';

class EditScreen extends StatefulWidget {
  final DataModel dataModel;
  const EditScreen({super.key, required this.dataModel});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController colorController;
  late TextEditingController capacityController;
  bool _updating = false;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.dataModel.id ?? '');
    nameController = TextEditingController(text: widget.dataModel.name ?? '');
    colorController = TextEditingController(text: widget.dataModel.data?.color ?? '');
    capacityController = TextEditingController(text: widget.dataModel.data?.capacity ?? '');
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    colorController.dispose();
    capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Data")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _updating
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(labelText: 'ID'),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: colorController,
              decoration: const InputDecoration(labelText: 'Color'),
            ),
            TextField(
              controller: capacityController,
              decoration: const InputDecoration(labelText: 'Capacity'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateData,
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateData() async {
    setState(() {
      _updating = true;
    });

    final updateUrl = "${Urls.getAllData}/${widget.dataModel.id}";
    final payload = {
      "name": nameController.text.trim(),
      "data": {
        "color": colorController.text.trim(),
        "capacity": capacityController.text.trim(),
      }
    };

    final NetworkResponse response = await NetworkCaller.putRequest(
      url: updateUrl,
      body: payload,
    );

    setState(() {
      _updating = false;
    });

    if (response.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Updated Successfully")));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed: ${response.errorMassage}")));
    }
  }
}
