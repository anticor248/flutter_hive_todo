import 'package:flutter/material.dart';
import 'package:flutter_todo_hive/data/local_storage.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../models/task_model.dart';

class TaskItem extends StatefulWidget {
  TaskItem({Key? key, required this.task}) : super(key: key);
  Task task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final TextEditingController _editedTaskController = TextEditingController();

  //to update localstorage
  late LocalStorage _localStorage;

  @override
  void initState() {
    //to update localstorage
    _localStorage = locator<LocalStorage>();
    //
    super.initState();
    _editedTaskController.text = widget.task.name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8, left: 8, right: 8),
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          blurRadius: 5,
          spreadRadius: 2,
          color: Colors.grey.withOpacity(.33),
        )
      ], color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
      width: MediaQuery.of(context).size.width,
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            widget.task.isCompleted = !widget.task.isCompleted;

            //to update localstorage
            _localStorage.updateTask(task: widget.task);
            //
            setState(() {});
          },
          child: widget.task.isCompleted
              ? Icon(
                  Icons.check_circle_rounded,
                  size: 34,
                  color: Colors.green,
                )
              : Icon(
                  Icons.circle_outlined,
                  size: 34,
                ),
        ),
        title: widget.task.isCompleted
            ? Text(
                widget.task.name,
                style: widget.task.isCompleted
                    ? TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: Colors.black38,
                      )
                    : TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
              )
            : TextField(
                controller: _editedTaskController,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                onSubmitted: (newName) {
                  widget.task.name = newName;

                  //to update localstorage
                  _localStorage.updateTask(task: widget.task);
                  //

                  setState(() {});
                }),
        trailing: Text(
          DateFormat('HH:mm').format(widget.task.createdAt),
        ),
      ),
    );
  }
}
