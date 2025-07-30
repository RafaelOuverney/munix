import 'package:hive_flutter/hive_flutter.dart';
import 'package:munix/models/playlist_model.dart';
import 'package:munix/models/track_model.dart';
import 'package:munix/models/artist_model.dart';

class StorageService {
  static const String _playlistBox = 'playlists';
  static const String _favoritesBox = 'favorites';
  static const String _trackCacheBox = 'trackCache';
  static const String _favoriteArtistsBox = 'favoriteArtists';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(_playlistBox);
    await Hive.openBox<Map>(_favoritesBox);
    await Hive.openBox<Map>(_trackCacheBox);
    await Hive.openBox<Map>(_favoriteArtistsBox);
  }

  // Playlists (1:N relationship)
  static Future<void> savePlaylist(Playlist playlist) async {
    final box = Hive.box<Map>(_playlistBox);
    await box.put(playlist.id, playlist.toJson());
  }

  static Future<List<Playlist>> getPlaylists() async {
    final box = Hive.box<Map>(_playlistBox);
    return box.values
        .map((json) => Playlist.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  static Future<void> deletePlaylist(String id) async {
    final box = Hive.box<Map>(_playlistBox);
    await box.delete(id);
  }

  // Favorite Artists (N:N relationship)
  static Future<void> addFavoriteArtist(String userId, Artist artist) async {
    final box = Hive.box<Map>(_favoriteArtistsBox);
    final key = '${userId}_${artist.id}';
    await box.put(key, {
      'userId': userId,
      'artistId': artist.id,
      'artist': artist.toJson(),
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  static Future<void> removeFavoriteArtist(String userId, String artistId) async {
    final box = Hive.box<Map>(_favoriteArtistsBox);
    final key = '${userId}_$artistId';
    await box.delete(key);
  }

  static Future<List<Artist>> getFavoriteArtists(String userId) async {
    final box = Hive.box<Map>(_favoriteArtistsBox);
    return box.values
        .where((json) => json['userId'] == userId)
        .map((json) => Artist.fromJson(Map<String, dynamic>.from(json['artist'])))
        .toList();
  }

  // Track Cache
  static Future<void> cacheTrack(Track track) async {
    final box = Hive.box<Map>(_trackCacheBox);
    await box.put(track.id, track.toJson());
  }

  static Future<Track?> getCachedTrack(String id) async {
    final box = Hive.box<Map>(_trackCacheBox);
    final json = box.get(id);
    return json != null ? Track.fromJson(Map<String, dynamic>.from(json)) : null;
  }
}
