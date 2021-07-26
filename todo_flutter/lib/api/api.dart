import 'package:dio/dio.dart';
import 'package:todo_flutter/model/todo.dart';

class DioApi {
  Dio _dio = Dio();
  String _url = 'http://localhost:5500/';

  Future<List<Todo>> getAllTodos() async {
    Response response = await _dio.get(_url + 'todos');
    List<Todo> todoList = [];
    if (response.statusCode != 200) {
      print(response.statusCode);
    } else {
      var jsonStringList = response.data as List;
      todoList = jsonStringList.map((e) => Todo.fromJson(e)).toList();
    }
    return todoList;
  }
}
