import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/widgets/toast.dart';

class TaskProvider extends ChangeNotifier {
  bool isLoading = false;

  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //User? user = FirebaseAuth.instance.currentUser;
  late CollectionReference _todoCollection;

  int businessTodoCount = 0;
  int personalTodoCount = 0;
  int completedTodoCount = 0;

  // Initiate with todos
  TaskProvider() {
    _todoCollection = _firestore
        .collection('Tasks')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Todos');
    getTodos();
  }

  //this fetches all todos from firebase

  Future<void> getTodos() async {
    isLoading = true;
    notifyListeners();

    try {
      final querySnapshot = await _todoCollection
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
          .get();
      _todos = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        //updateParameters(data['type'], data['isCompleted']);

        count();

        return Todo(
          id: doc.id,
          title: data['title'],
          description: data['description'],
          place: data['place'],
          time: data['time'],
          type: data['type'],
          isCompleted: data['isCompleted'],
        );
      }).toList();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print('Failed to load todos: $e');
      showToast('Error getting data');
    }
  }

  //this function adds a todo

  Future<void> addTodo(Map<String, dynamic> thisTodo) async {
    isLoading = true;
    notifyListeners();

    try {
      final newTodo = thisTodo;

      final docRef = await _todoCollection.add(newTodo);

      final todo = Todo(
        id: docRef.id,
        title: thisTodo['title'],
        description: thisTodo['description'],
        place: thisTodo['place'],
        time: thisTodo['time'],
        type: thisTodo['type'],
        isCompleted: false,
      );
      _todos.add(todo);
      showToast('New task successfully added');

      isLoading = false;
      //updateParameters(thisTodo['type'], false);

      count();

      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print('Failed to add todo: $e');
      showToast('Connection error');
    }
  }

  //this updates a todo when a user edits it

  Future<void> updateTodo(Todo updatedTodo) async {
    isLoading = true;
    notifyListeners();

    try {
      final docRef = _todoCollection.doc(updatedTodo.id);
      await docRef.update({
        'title': updatedTodo.title,
        'description': updatedTodo.description,
        'place': updatedTodo.place,
        'time': updatedTodo.time,
        'type': updatedTodo.type,
        'isCompleted': updatedTodo.isCompleted,
      });
      final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
      if (index >= 0) {
        _todos[index] = updatedTodo;
      }
      //updateParameters(updatedTodo.type, updatedTodo.isCompleted);
      count();

      isLoading = false;
      notifyListeners();
      showToast('Todo updated');
    } catch (error) {
      isLoading = false;
      notifyListeners();
      print('Error updating todo: $error');
      showToast('Could not update changes');
    }
  }

  //tis updattes a todo status as completed

  Future<void> updateTodoStatus(Todo todo, bool isCompleted) async {
    isLoading = true;
    notifyListeners();

    try {
      await _todoCollection.doc(todo.id).update({'isCompleted': isCompleted});
      todo.isCompleted = isCompleted;

      count();

      isLoading = false;
      notifyListeners();
      showToast('Task complete');
    } catch (e) {
      print('Failed to update todo status: $e');
      showToast('Error');
    }
  }

  //this deletes a todo

  Future<void> deleteTodo(Todo todo) async {
    isLoading = true;
    notifyListeners();

    try {
      await _todoCollection.doc(todo.id).delete();
      _todos.remove(todo);

      count();

      isLoading = false;
      notifyListeners();
      showToast('Task removed');
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print('Failed to delete todo: $e');
      showToast('Unable to remove task');
    }
  }

  //these streams and functions are used to update business, personal and isCompleted values required to show on th UI

  Stream<int> countCompletedTasks() {
    return _todoCollection
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
        .where('isCompleted', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  Stream<int> countBusinessTasks() {
    return _todoCollection
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
        .where('type', isEqualTo: 'Business')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  Stream<int> countPersonalTasks() {
    return _todoCollection
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
        .where('type', isEqualTo: 'Personal')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  void count() {
    countCompletedTasks().listen((count) {
      completedTodoCount = count;
      notifyListeners();
    });
    countBusinessTasks().listen((count) {
      businessTodoCount = count;
      notifyListeners();
    });
    countPersonalTasks().listen((count) {
      personalTodoCount = count;
      notifyListeners();
    });
  }
}
