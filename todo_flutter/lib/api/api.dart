import 'package:dio/dio.dart';
import 'package:todo_flutter/model/todo.dart';

class DioApi {
  Dio _dio = Dio();
  String _url = 'http://localhost:5500/';

  /// 이 메서드는 DB의 모든 Todo 아이템을 받아와서 리스트에 담는다.
  /// http의 response.body와 달리 Dio의 response.data는
  /// json.decode(response.body)가 실행된 결과와 같기 때문에 파싱 단계를 줄일 수 있다.
  Future<List<Todo>> getAllTodos() async {
    final response = await _dio.get(_url + 'todos');
    List<Todo> todoList = [];
    if (response.statusCode != 200) {
      print('Failed to get the todo list:: ${response.statusCode}');
    } else {
      var jsonStringList = response.data as List;
      todoList = jsonStringList.map((e) => Todo.fromJson(e)).toList();
    }
    return todoList;
  }

  /// 이 메서드는 Todo 아이템을 하나씩 받아온다.
  /// 다만 이 앱에서는 위의 메서드로 모든 Todo 아이템을 받아 리스트로 관리하기 때문에 필요가 없어 쓰지 않는다.
  // Future<Todo?> getTodo(int index) async {
  //   final response = await _dio.get(_url + 'todos/$index');
  //   Todo? todo;
  //   if (response.statusCode != 200) {
  //     print('Failed to get the todo');
  //   } else {
  //     todo = Todo.fromJson(response.data);
  //   }
  //   return todo;
  // }

  /// 이 메서드는 새로운 Todo 아이템을 생성한다. index는 DB에서 auto increment로 관리된다.
  void addTodo(String name, String title) async {
    final response =
        await _dio.post(_url + 'todos', queryParameters: {'name': name, 'title': title});
    if (response.statusCode == 201) {
      print('Create Success');
    } else {
      print('Create Failure:: ${response.statusCode}');
    }
  }

  /// 이 메서드는 선택된 Todo 아이템을 업데이트한다.
  /// put이 아니라 patch를 쓰고 있으나 세 가지 인자를 다 보냄으로 put을 사용해도 무방하다.
  /// 다만 put을 쓰는 경우 인자를 빈 상태로 보내면 그대로 저장되어 기존 데이터를 잃을 수 있음에 유의한다.
  void updateTodo(int index, String name, String title) async {
    final response = await _dio.patch(_url + 'todos/$index',
        queryParameters: {'index': index, 'name': name, 'title': title});
    if (response.statusCode == 200) {
      print('Update Success');
    } else {
      print('Update Failure:: ${response.statusCode}');
    }
  }

  /// 이 메서드는 선택된 Todo 아이템을 삭제한다.
  void deleteTodo(int index) async {
    final response = await _dio.patch(_url + 'todos/$index', queryParameters: {'index': index});
    if (response.statusCode == 200) {
      print('Delete Success');
    } else {
      print('Delete failure:: ${response.statusCode}');
    }
  }
}
