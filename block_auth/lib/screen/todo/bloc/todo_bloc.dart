import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/model/todo_model.dart';
import 'todo_event.dart';
import 'todo_state.dart';
import '../todo_repository.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;
  List<Todo> _todos = [];

  TodoBloc(this.repository) : super(TodoInitial()) {
    on<LoadTodos>((event, emit) {
      emit(TodoLoading());
      _todos = repository.fetchTodos();
      emit(TodosLoaded(List.from(_todos)));
    });

    on<AddTodo>((event, emit) {
      _todos.add(event.todo);
      emit(TodosLoaded(List.from(_todos)));
    });

    on<UpdateTodo>((event, emit) {
      final index = _todos.indexWhere((t) => t.id == event.id);
      if (index != -1) {
        _todos[index] = Todo(
          id: event.id,
          title: event.title,
          description: event.description,
        );
      }
      emit(TodosLoaded(List.from(_todos)));
    });

    on<DeleteTodo>((event, emit) {
      _todos.removeWhere((t) => t.id == event.id);
      emit(TodosLoaded(List.from(_todos)));
    });
  }
}
