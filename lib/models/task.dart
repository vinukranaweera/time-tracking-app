class Task {
  final String id;
  final String name;
  //   final bool isDefault; // To identify if it's a system default or user-added

  Task({
    required this.id,
    required this.name,
    // this.isDefault = false
  });

  // Convert a JSON object to an Task instance
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(id: json['id'], name: json['name']);
  }

  // Convert an Task instance to a JSON object
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
