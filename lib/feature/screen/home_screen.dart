import 'package:flutter/material.dart';
import 'package:sm_t/core/models/data_model.dart';
import 'package:sm_t/core/models/network_response.dart';
import 'package:sm_t/core/services/network_caller.dart';
import 'package:sm_t/core/utils/urls.dart';
import 'create_screen.dart';
import 'edit_screen.dart'; // Edit screen route

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _progress = false;
  List<DataModel> _data = [];

  @override
  void initState() {
    super.initState();
    _getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')
      ),

      body: _progress
          ? const Center(child: CircularProgressIndicator())
          : _data.isEmpty
          ? const Center(child: Text("No data found"))
          : ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          final item = _data[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(item.name ?? 'No Name'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Color: ${item.data?.color ?? "N/A"}'),
                  Text('Capacity: ${item.data?.capacity ?? "N/A"}'),
                  const Divider(),
                  ButtonBar(
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditScreen(dataModel: item),
                            ),
                          );
                          if (result == true) {
                            _getNewTaskList(); // Refresh after update
                          }
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          _confirmDelete(item.id!);
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateScreen()),
          );
          if (result == true) {
            _getNewTaskList(); // Refresh list if data was added
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _getNewTaskList() async {
    _data.clear();
    _progress = true;
    setState(() {});

    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.getAllData);

    if (response.isSuccess) {
      final List<dynamic> jsonList = response.responseData;
      _data = jsonList.map((e) => DataModel.fromJson(e)).toList();
    } else {
      print("API Error: ${response.errorMassage}");
    }

    _progress = false;
    setState(() {});
  }

  Future<void> _confirmDelete(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete"),
        content: const Text("Are you sure you want to delete this item?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
        ],
      ),
    );

    if (confirm == true) {
      final deleteUrl = "${Urls.getAllData}/$id"; // Assuming REST endpoint like /data/1
      final NetworkResponse response = await NetworkCaller.deleteRequest(url: deleteUrl);
      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Deleted successfully")));
        _getNewTaskList();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to delete: ${response.errorMassage}")));
      }
    }


  }
}
