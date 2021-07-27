import 'package:flutter/material.dart';
import 'package:todo_flutter/api/api.dart';

class EditPage extends StatefulWidget {
  final String methodName;
  final int index;
  EditPage(this.methodName, this.index);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  DioApi _api = DioApi();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.methodName),
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text('Do you really want to delete this item?'),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                                _api.deleteTodo(widget.index);
                              }),
                        ],
                      );
                    });
              },
            )
          ],
        ),
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.length < 2) {
                      return 'You should fill in the blank with more than 2 letters';
                    }
                  },
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.length < 5) {
                      return 'You should fill in the blank with more than 5 letters';
                    }
                  },
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextButton(
                  child: Text(widget.methodName.split('/').first.toUpperCase()),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.methodName.contains('Add')) {
                        _api.addTodo(_nameController.text, _titleController.text);
                      } else {
                        _api.updateTodo(widget.index, _nameController.text, _titleController.text);
                      }
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
