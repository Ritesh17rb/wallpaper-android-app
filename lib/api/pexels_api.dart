// lib/api/pexels_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class PexelsApi {
  static const _base = 'https://api.pexels.com/v1';

  static Future<List<Map<String, dynamic>>> curated({int page = 1, int perPage = PER_PAGE}) async {
    final url = Uri.parse('$_base/curated?page=$page&per_page=$perPage');
    final res = await http.get(url, headers: {'Authorization': PEXELS_API_KEY});
    if (res.statusCode != 200) throw Exception('Failed to load curated');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return (data['photos'] as List).cast<Map<String, dynamic>>();
  }

  static Future<List<Map<String, dynamic>>> search(String query, {int page = 1, int perPage = PER_PAGE}) async {
    final url = Uri.parse('$_base/search?query=${Uri.encodeComponent(query)}&page=$page&per_page=$perPage');
    final res = await http.get(url, headers: {'Authorization': PEXELS_API_KEY});
    if (res.statusCode != 200) throw Exception('Failed to search');
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return (data['photos'] as List).cast<Map<String, dynamic>>();
  }
}
