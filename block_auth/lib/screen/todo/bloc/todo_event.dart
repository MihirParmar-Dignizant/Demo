
import '../../home/model/todo_model.dart';

abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final Todo todo;
  AddTodo(this.todo);
}

class UpdateTodo extends TodoEvent {
  final String id;
  final String title;
  final String description;
  UpdateTodo(this.id, this.title, this.description);
}

class DeleteTodo extends TodoEvent {
  final String id;
  DeleteTodo(this.id);
}
