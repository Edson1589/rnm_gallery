import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';
import '../models/episode.dart';

class ApiClient {
  static const String _base = 'https://rickandmortyapi.com/api';
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Character>> fetchCharacters({int page = 1}) async {
    final uri = Uri.parse('$_base/character?page=$page');
    final res = await _client.get(uri);

    if (res.statusCode != 200) {
      throw Exception('Error ${res.statusCode} al cargar personajes');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final results = (data['results'] as List).cast<Map<String, dynamic>>();
    return results.map(Character.fromJson).toList();
  }

  Future<List<Episode>> fetchEpisodesByUrls(List<String> urls) async {
    final limited = urls.take(5).toList();

    final futures = limited.map((u) async {
      final res = await _client.get(Uri.parse(u));
      if (res.statusCode != 200) {
        throw Exception('Error obteniendo episodio en $u');
      }
      final map = jsonDecode(res.body) as Map<String, dynamic>;
      return Episode.fromJson(map);
    });

    return Future.wait(futures);
  }

  void close() {
    _client.close();
  }
}
