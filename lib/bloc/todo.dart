import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/todo_state.dart';
import 'package:todo/data/todo_service.dart';
import 'package:todo/model/todo_hive.dart';

class Todo extends Cubit<TodoState> {
  Todo() : super(TodoInitial()) {
    fetchAllTodos();
  }

  final TodoService service = TodoService();

  Future<void> createTodo(TodoDb todo) async {
    emit(TodoLoading());
    try {
      await service.createTodo(todo);
      await fetchAllTodos();
    } catch (e) {
      emit(TodoFailure(e.toString()));
    }
  }

  Future<void> fetchAllTodos() async {
    emit(TodoLoading());
    try {
      List<TodoDb> list = await service.getTodos();
      emit(TodoSuccess(list));
    } catch (e) {
      emit(TodoFailure(e.toString()));
    }
  }
}
