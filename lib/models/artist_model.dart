class Artist {
  final String id;
  final String name;
  final String image;
  final String website;

  Artist({
    required this.id,
    required this.name,
    required this.image,
    required this.website,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'].toString(),
      name: json['name'],
      image: json['image'],
      website: json['website'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'website': website,
    };
  }
}
