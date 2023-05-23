import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/utils/constants.dart';

import '../providers/task_provider.dart';


//this is displayed to confirm if user wants to mark task as completed
void showConfirmCompleteDialog(BuildContext context, Todo todo) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Consumer<TaskProvider>(
        builder: (context, todoProvider, child) => AlertDialog(
          title: const Text(
            'Complete Task',
            style: TextStyle(fontFamily: 'Bold'),
          ),
          content: const Text(
            'Are you sure you want to mark this task as done?',
            style: TextStyle(fontFamily: 'Medium'),
          ),
          actions: [
            TextButton(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30), color: primary),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('Cancel',
                        style: TextStyle(
                            fontFamily: 'SemiBold', color: Colors.white)),
                  )),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.green),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('Confirm',
                        style: TextStyle(
                            fontFamily: 'SemiBold', color: Colors.white)),
                  )),
              onPressed: () {
                todoProvider.updateTodoStatus(todo, true);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        ),
      );
    },
  );
}
