class Todo {
  String title;
  bool isComplete;

  Todo({this.title, this.isComplete = false});

  Todo.fromMap(Map map)
      : this.title = map['title'],
        this.isComplete = map['isComplete'];

  Map toMap() {
    return {
      'title': this.title,
      'isComplete': this.isComplete,
    };
  }
}
