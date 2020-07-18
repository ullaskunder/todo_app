import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/pages/add_item_page.dart';
import 'package:todo_app/services/todo.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> _todoList = new List<Todo>();
  SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();
    _todoList.add(Todo(title: 'Welcome'));
    _initSharedPreferences();
  }

  void _initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO'),
        centerTitle: true,
      ),
      body: _todoList.isNotEmpty ? _listData() : _emptyData(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem(),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _listData() {
    return ListView.builder(
      itemCount: _todoList.length,
      itemBuilder: (context, index) {
        return _listItem(_todoList[index]);
      },
    );
  }

  Widget _emptyData() {
    return Center(
      child: Text('Add new Items'),
    );
  }

  Widget _listItem(Todo item) {
    return Dismissible(
      key: Key(item.hashCode.toString()),
      onDismissed: (direction) => _removeFromList(item),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red.shade600,
        padding: EdgeInsets.only(
          left: 12.0,
        ),
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: ListTile(
        title: Text(item.title),
        trailing: Checkbox(value: item.isComplete, onChanged: null),
        onTap: () => _setComplete(item),
        onLongPress: () => _editItem(item),
      ),
    );
  }

  void _addItem() {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => AddItemPage(),
      ),
    )
        .then(
      (item) {
        if (item != null) _addToTodoList(Todo(title: item));
      },
    );
  }

  void _editItem(Todo item) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => AddItemPage(
          title: item.title,
        ),
      ),
    )
        .then(
      (title) {
        if (title != null) _addEditedItem(item, title);
      },
    );
  }

  void _setComplete(Todo item) {
    setState(() {
      item.isComplete = !item.isComplete;
      //_saveData();
    });
  }

  void _removeFromList(Todo item) {
    _todoList.remove(item);
    if (_todoList.isEmpty) setState(() {});
    _saveData();
  }

  void _addToTodoList(Todo item) async {
    setState(() {
      _todoList.add(item);
    });
    _saveData();
  }

  void _addEditedItem(Todo item, String title) {
    setState(() {
      item.title = title;
    });
    _saveData();
  }

  void _saveData() {
    List<String> _spList =
        _todoList.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList('list', _spList);
  }

  void _loadData() {
    List<String> _spList = sharedPreferences.getStringList('list');
    _todoList = _spList.map((item) => Todo.fromMap(json.decode(item))).toList();
    setState(() {});
  }
}
