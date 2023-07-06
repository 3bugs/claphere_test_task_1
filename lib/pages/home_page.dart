import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/todo.dart';
import '../todo_repository.dart';
import '../widgets/todo_item.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<Todo>? _todoList;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(
            onPressed: _loadData,
            child: const Text('Load data'),
          ),
          Expanded(
            child: Stack(
              children: [
                ListView(
                  children: [
                    for (final todo in _todoList ?? []) TodoItem(todo: todo),
                  ],
                ),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final todoList = await ref.read(repositoryProvider).fetchTodos();

    setState(() {
      _todoList = todoList;
      _isLoading = false;
    });
  }
}
