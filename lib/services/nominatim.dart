import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foss_warn/constants.dart' as constants;
import 'package:http/http.dart' as http;

final nominatimApiProvider = Provider(
  (ref) => Nominatim(serverUrl: "https://nominatim.openstreetmap.org"),
);

class Nominatim {
  const Nominatim({required String serverUrl}) : _baseUrl = serverUrl;

  final String _baseUrl;

  Future<List<dynamic>> searchCity(String query) async {
    var url =
        Uri.parse("$_baseUrl/search?q=$query&format=json&featureType=city");

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'User-Agent': constants.httpUserAgent,
      },
    );

    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}
