class Task {
  late int id;
  late String title;
  late String description;
  late bool isCompleted;
  late DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
