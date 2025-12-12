import 'package:hive/hive.dart';
import 'package:todo/model/todo_hive.dart';

class TodoService {
  static const String todoBox = "TODOBOX";
  Box<TodoDb>? _box;

  Future<Box<TodoDb>> get box async {
    _box ??= await Hive.openBox<TodoDb>(todoBox);
    return _box!;
  }

  Future<void> createTodo(TodoDb todo) async {
    final openBox = await box;
    await openBox.add(todo);
  }

  Future<List<TodoDb>> getTodos() async {
    final openBox = await box;
    return openBox.values.toList();
  }

 
}
