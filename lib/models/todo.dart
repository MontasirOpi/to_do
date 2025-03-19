class Todo {
  final String id;
  String title;
  String description;
  final int createdAt;
  String status; // 'ready', 'pending', 'completed'

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.status = 'ready',
  });

  // For CSV
  List<String> toCsvRow() {
    return [id, title, description, createdAt.toString(), status];
  }

  static Todo fromCsvRow(List<dynamic> row) {
    return Todo(
      id: row[0],
      title: row[1],
      description: row[2],
      createdAt: int.parse(row[3]),
      status: row[4],
    );
  }

  // For JSON
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: json['created_at'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'created_at': createdAt,
        'status': status,
      };
}
