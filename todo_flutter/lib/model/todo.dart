class Todo {
  /// index는 Todo 아이템의 번호, name은 작성한 사람의 이름, title은 Todo 아이템의 내용을 의미한다.
  /// 다만 이 앱은 연습 프로젝트이기 때문에 기기별로 name을 할당하지 않고 임의대로 입력할 수 있다.
  final int index;
  final String name;
  final String title;

  Todo({required this.index, required this.name, required this.title});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(index: json['index'] as int, name: json['name'], title: json['title']);
  }

  Map<String, dynamic> toJson() => {'index': index, 'name': name, 'title': title};
}
