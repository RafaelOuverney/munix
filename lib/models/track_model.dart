class Track {
  final String id;
  final String name;
  final String artistName;
  final String albumName;
  final String image; 
  final String audio;

  Track({
    required this.id,
    required this.name,
    required this.artistName,
    required this.albumName,
    required this.image,
    required this.audio,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'],
      name: json['name'],
      artistName: json['artist_name'],
      albumName: json['album_name'],
      image: json['album_image'],
      audio: json['audio'],
    );
  }
}