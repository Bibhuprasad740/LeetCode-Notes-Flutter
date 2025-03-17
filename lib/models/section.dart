class Section {
  final String id;
  final String name;
  final String dateAdded;
  final String dateModified;

  Section({
    required this.id,
    required this.name,
    required this.dateAdded,
    required this.dateModified,
  });

  // Optional: Add a method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dateAdded': dateAdded,
      'dateModified': dateModified,
    };
  }

  // Optional: Add a factory constructor for JSON deserialization
  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['_id'],
      name: json['name'],
      dateAdded: json['createdAt'],
      dateModified: json['updatedAt'],
    );
  }
}
