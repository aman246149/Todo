import 'package:todo/model/todo_hive.dart';

abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoSuccess extends TodoState {
  final List<TodoDb> todoList;

  TodoSuccess(this.todoList);
}

class TodoFailure extends TodoState {
  final String error;

  TodoFailure(this.error);
}
