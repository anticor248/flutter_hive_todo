import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_todo_hive/data/local_storage.dart';
import 'package:flutter_todo_hive/main.dart';
import 'package:flutter_todo_hive/widgets/task_list_items.dart';

import 'models/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Task> _allTasks;
  //Local storage call
  late LocalStorage _localStorage;

  @override
  void initState() {
    //local storage call
    _localStorage = locator<LocalStorage>();

    _allTasks = <Task>[];
    super.initState();

    //local storage call
    _getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text('TODO Hive'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                _showAddTaskBottomSheet(context);
              },
              icon: Icon(Icons.add_circle_outline))
        ],
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              //bottom to top list
              //reverse: true,

              itemCount: _allTasks.length,
              itemBuilder: (context, index) {
                //to add new item bottom on the list, use reversedIndex as integer below
                int reversedIndex = _allTasks.length - 1 - index;
                //each current task from alltask with index, important
                var _currentTask = _allTasks[reversedIndex];

                return Dismissible(
                  background: Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 32,
                          ),
                        ],
                      ),
                    ),
                  ),
                  key: Key(_currentTask.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _allTasks.removeAt(index);
                    _localStorage.deleteTask(task: _currentTask);
                    setState(() {});
                  },
                  child: TaskItem(
                    task: _currentTask,
                  ),
                );
              },
            )
          : Center(
              child: Text(
                'Add New Tasks',
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
            ),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                left: 10,
                right: 10,
                top: 5),
            width: MediaQuery.of(context).size.width,
            child: TextField(
              autofocus: true,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 8,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Task Title',
                hintStyle: TextStyle(
                  fontSize: 18,
                ),
              ),
              onSubmitted: (value) {
                //After submit for auto close BottomSheet
                Navigator.of(context).pop();
                DatePicker.showTimePicker(context, showSecondsColumn: false,
                    onConfirm: (time) async {
                  var newTask = Task.create(name: value, createdAt: time);
                  //to add newTask created and add to allTask list
                  _allTasks.add(newTask);

                  //to add newTask bottom on the list
                  //_allTasks.insert(0, newTask);
                  //adding newTask localstorage database
                  await _localStorage.addTask(task: newTask);
                  setState(() {});
                });
              },
            ),
          );
        });
  }

  void _getAllTaskFromDb() async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {});
  }
}
