import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'model/todo_model.dart';

class HomeRepository {
  final String baseUrl = "https://mood-meal-backend.onrender.com/api/v1/auth";

  Future<void> logout(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to logout");
    }
  }

  Future<List<Todo>> getTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosString = prefs.getStringList('todos') ?? [];
    return todosString.map((t) => Todo.fromJson(t)).toList();
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final todosString = todos.map((t) => t.toJson()).toList();
    await prefs.setStringList('todos', todosString);
  }

  Future<void> addTodo(Todo todo) async {
    final todos = await getTodos();
    todos.add(todo);
    await saveTodos(todos);
  }

  Future<void> updateTodo(String id, String title, String description) async {
    final todos = await getTodos();
    final index = todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      todos[index].title = title;
      todos[index].description = description;
      await saveTodos(todos);
    }
  }

  Future<void> deleteTodo(String id) async {
    final todos = await getTodos();
    todos.removeWhere((t) => t.id == id);
    await saveTodos(todos);
  }
}
