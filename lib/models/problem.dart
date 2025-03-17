class Problem {
  final String id;
  final String sectionId;
  final String name;
  final String leetCodeUrl;
  final String? description;
  final String? sampleInput;
  final String? sampleOutput;
  final List<String> intuition;
  final String? code;
  final List<String>? tags;
  final String? difficulty;
  final String? imageUrl;
  final String dateAdded;
  final String dateModified;

  Problem({
    required this.id,
    required this.sectionId,
    required this.name,
    required this.leetCodeUrl,
    this.description,
    this.sampleInput,
    this.sampleOutput,
    required this.intuition,
    this.code,
    this.tags,
    this.difficulty,
    this.imageUrl,
    required this.dateAdded,
    required this.dateModified,
  });

  // Optional: Add a factory constructor for JSON deserialization
  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      id: json['_id'],
      sectionId: json['sectionId'],
      name: json['questionName'],
      leetCodeUrl: json['leetcodeLink'],
      description: json['description'],
      sampleInput: json['sampleInput'],
      sampleOutput: json['sampleOutput'],
      intuition: List<String>.from(json['intuition']),
      code: json['code'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      difficulty: json['difficulty'],
      imageUrl: json['imageUrl'],
      dateAdded: json['createdAt'],
      dateModified: json['updatedAt'],
    );
  }

  // Optional: Add a method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'questionName': name,
      'sectionId': sectionId,
      'leetcodeLink': leetCodeUrl,
      'description': description,
      'sampleInput': sampleInput,
      'sampleOutput': sampleOutput,
      'intuition': intuition,
      'code': code,
      'tags': tags,
      'difficulty': difficulty,
      'imageUrl': imageUrl,
    };
  }
}
