import 'package:flutter/material.dart';
import 'package:sqlite_database_crud/models/task.dart';
import 'package:sqlite_database_crud/service/database_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseService _databaseService = DatabaseService.instance;
  TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sqlite Database Example',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: _addTaskButton(),
      body: _taskList(),
    );
  }

  Widget _taskList() {
    return FutureBuilder(
        future: _databaseService.getTaskList(),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                Task _task = snapshot.data![index];
                return InkWell(
                  onLongPress: () {
                    _databaseService.deleteTask(_task.id);
                    setState(() {});
                  },
                  child: ListTile(
                    title: Text(_task.content),
                    trailing: Checkbox(
                      value: _task.status == 1,
                      onChanged: (value) {
                        _databaseService.updateTask(
                            _task.id, value == true ? 1 : 0);
                        setState(() {});
                      },
                    ),
                  ),
                );
              });
        });
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: () {
        showPopup();
      },
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      backgroundColor: Colors.blue,
    );
  }

  void showPopup() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: Text(
              "Insert Data",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.all(0),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              Column(
                children: [
                  TextField(
                    controller: _editingController,
                    decoration: InputDecoration(
                        hintText: 'Add Task ..',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_editingController.text.toString() == '') return;
                      _databaseService.insertTask(_editingController.text);
                      _editingController.text = '';
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  )
                ],
              )
            ],
          );
        });
  }
}
