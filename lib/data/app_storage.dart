import 'dart:convert';

import 'package:localstorage/localstorage.dart';

import '../models/todo.dart';

class AppStorage {
  static const keyTodoList = 'todo-list';

  static final AppStorage _instance = AppStorage._internal();
  final LocalStorage storage = LocalStorage('app_data.json');

  factory AppStorage() {
    return _instance;
  }

  AppStorage._internal();

  Future<List<Todo>> getTodoList() async {
    await storage.ready;
    final List list = jsonDecode(storage.getItem(keyTodoList));
    return List<Todo>.from(list.map((item) => Todo.fromJson(item)));
  }

  Future<void> setTodoList(List<Todo> todoList) async {
    await storage.ready;
    return storage.setItem(keyTodoList, jsonEncode(todoList));
  }
}