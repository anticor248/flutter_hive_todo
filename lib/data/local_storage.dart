import 'package:flutter_todo_hive/models/task_model.dart';
import 'package:hive/hive.dart';

abstract class LocalStorage {
  Future<void> addTask({required Task task});
  // ? this is for it can be null
  Future<Task?> getTask({required String id});
  Future<List<Task>> getAllTask();
  Future<bool> deleteTask({required Task task});
  Future<Task> updateTask({required Task task});
}

//This code is important for changing local storage type hive or secure hive or anyone you want
// it makes very simple that let us to change
class HiveLocalStorage extends LocalStorage {
  //setup metod hive
  //to open box this page
  late Box<Task> _taskBox;
  //initialize HiveBox
  //TODO check here
  HiveLocalStorage() {
    //same name with main.dart
    _taskBox = Hive.box<Task>('tasks');
  }

  @override
  Future<void> addTask({required Task task}) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required Task task}) async {
    await task.delete();
    return true;
  }

  @override
  Future<List<Task>> getAllTask() async {
    List<Task> _allTask = <Task>[];
    _allTask = _taskBox.values.toList();
    if (_allTask.isNotEmpty) {
      //to sort all task in list to show by created time
      //b compare a means to add top for new tasks
      _allTask.sort(
        (Task a, Task b) => a.createdAt.compareTo(b.createdAt),
      );
    }
    //to remove problem return, add async
    return _allTask;
  }

  @override
  Future<Task?> getTask({required String id}) async {
    if (_taskBox.containsKey(id)) {
      return _taskBox.get(id);
    } else {
      return null;
    }
  }

  @override
  Future<Task> updateTask({required Task task}) async {
    await task.save();
    return task;
  }
}
