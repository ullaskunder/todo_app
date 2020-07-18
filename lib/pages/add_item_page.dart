import 'package:flutter/material.dart';

class AddItemPage extends StatefulWidget {
  final String title;
  AddItemPage({this.title});
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(text: widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              onEditingComplete: () => _saveItem(),
            ),
            FlatButton(
              onPressed: () => _saveItem(),
              child: Text(
                'SAVE',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveItem() {
    FocusScope.of(context).unfocus();
    if (_controller.text.isNotEmpty)
      Navigator.of(context).pop(_controller.text);
  }
}
