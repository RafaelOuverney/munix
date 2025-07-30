class Playlist {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final List<String> trackIds;

  Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.trackIds,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      trackIds: List<String>.from(json['trackIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'trackIds': trackIds,
    };
  }
}
