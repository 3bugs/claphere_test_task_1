import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'data/mocked_data.dart';
import 'models/todo.dart';

class TodoRepository {
  Future<List<Todo>> fetchTodos() async {
    const apiUrl = 'https://jsonplaceholder.typicode.com/todos';

    final response = await http.get(Uri.parse(apiUrl));
    final List responseList = jsonDecode(response.body);
    return List<Todo>.from(responseList.map((item) => Todo.fromJson(item)));
  }
}

// A mocked implementation of TodoRepository
class FakeRepository implements TodoRepository {
  @override
  Future<List<Todo>> fetchTodos() async {
    return Future.delayed(const Duration(seconds: 1), () {
      return mockedTodoList;
    });
  }
}

final repositoryProvider = Provider((ref) => TodoRepository());

final todoListProvider = FutureProvider((ref) async {
  final repository = ref.read(repositoryProvider);

  return repository.fetchTodos();
});
