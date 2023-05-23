class Todo {
  final String id;
  final String title;
  final String description;
  final String place;
  final String time;
  final String type;
  bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.place,
    required this.time,
    required this.type,
    required this.isCompleted,
  });
}
