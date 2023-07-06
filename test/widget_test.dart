import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:riverpod_mock_api_response/main.dart';
import 'package:riverpod_mock_api_response/todo_repository.dart';
import 'package:riverpod_mock_api_response/widgets/todo_item.dart';
import 'package:riverpod_mock_api_response/data/mocked_data.dart';

void main() {
  testWidgets('override repositoryProvider', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [repositoryProvider.overrideWithValue(FakeRepository())],
        child: const MyApp(),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(TextButton), findsOneWidget);
    await tester.tap(find.byType(TextButton));

    // Rebuild: start loading data
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Rebuild: finish loading data
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Rendered TodoItem with the data returned by FakeRepository
    expect(
      tester.widgetList(find.byType(TodoItem)),
      mockedTodoList.map(
        (item) => isA<TodoItem>()
            .having((s) => s.todo.userId, 'todo.userId', item.userId)
            .having((s) => s.todo.id, 'todo.id', item.id)
            .having((s) => s.todo.title, 'todo.title', item.title)
            .having((s) => s.todo.completed, 'todo.completed', item.completed),
      ),
    );
  });
}
