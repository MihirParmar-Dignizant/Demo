import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginRepository {
  final String baseUrl = "https://mood-meal-backend.onrender.com/api/v1/auth";

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userEmail': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded['success'] == true && decoded['data'] != null) {
        return decoded['data']; // contains token, refreshToken, user
      } else {
        throw Exception(decoded['message'] ?? "Login failed");
      }
    } else {
      debugPrint("Response body: ${response.body}");
      throw Exception("Failed to login: ${response.statusCode}");
    }
  }
}
