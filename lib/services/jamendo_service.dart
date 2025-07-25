import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:munix/models/track_model.dart';

class JamendoService {
  final String _clientId = '45940b58'; // <-- COLOQUE SUA CHAVE AQUI
  final String _baseUrl = 'https://api.jamendo.com/v3.0';

  Future<List<dynamic>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/genres/?client_id=$_clientId&format=json'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Track>> fetchPopularTracks({String? categoryId}) async {
    String url = '$_baseUrl/tracks/?client_id=$_clientId&format=json';
    if (categoryId != null) {
      url += '&musicinfo_genreid=$categoryId';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((trackJson) => Track.fromJson(trackJson)).toList();
    } else {
      throw Exception('Failed to load tracks');
    }
  }

  Future<List<Track>> searchTracks(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/tracks/?client_id=$_clientId&format=json&limit=20&search=$query'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((trackJson) => Track.fromJson(trackJson)).toList();
    } else {
      throw Exception('Failed to search tracks');
    }
  }

  Future<List<Track>> fetchTopTracks() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/tracks/?client_id=$_clientId&format=json&limit=50&orderby=popularity'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((trackJson) => Track.fromJson(trackJson)).toList();
    } else {
      throw Exception('Failed to load top tracks');
    }
  }
}