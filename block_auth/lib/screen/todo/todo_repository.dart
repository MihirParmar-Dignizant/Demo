import '../home/model/todo_model.dart';

class TodoRepository {
  final List<Todo> _storage = [];

  List<Todo> fetchTodos() {
    return List.from(_storage);
  }
}
