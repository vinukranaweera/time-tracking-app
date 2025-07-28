class Project {
  final String id;
  final String name;
  final bool isDefault; // To identify if it's a system default or user-added

  Project({required this.id, required this.name, this.isDefault = false});

  // Convert a JSON object to an Project instance
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(id: json['id'], name: json['name']);
  }

  // Convert an Project instance to a JSON object
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
