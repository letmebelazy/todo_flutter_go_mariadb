class Todo {
  final int index;
  final String name;
  final String title;

  Todo({required this.index, required this.name, required this.title});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(index: json['index'], name: json['name'], title: json['title']);
  }

  Map<String, dynamic> toJson() => {'index': index, 'name': name, 'title': title};
}
