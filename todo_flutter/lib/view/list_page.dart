import 'package:flutter/material.dart';
import 'package:todo_flutter/model/todo.dart';
import 'package:todo_flutter/api/api.dart';
import 'package:todo_flutter/view/edit_page.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  DioApi _api = DioApi();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Todo List'),
        ),
        body: Container(
          child: FutureBuilder<List<Todo>>(
              future: _api.getAllTodos(),
              builder: (_, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) {
                        return ListTile(
                          title: Text(snapshot.data![index].title),
                          subtitle: Text(snapshot.data![index].name),
                          onTap: () {
                            Navigator.push(
                                _,
                                MaterialPageRoute(
                                    builder: (_) => EditPage('Edit the item', index)));
                          },
                        );
                      });
                }
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => EditPage('Add an item', 0)));
          },
        ),
      ),
    );
  }
}
