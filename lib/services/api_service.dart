import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_voc/models/entry.dart';
import 'package:my_voc/secrets.dart';

class ApiService {
  final String baseUrl = 'od-api.oxforddictionaries.com';

  Future<Entry> getEntry(String word) async {
    var url = Uri.https(baseUrl, '/api/v2/entries/en/${word}');

    var response = await http.get(url, headers: {
      'app_id': kAppId,
      'app_key': kAppKey,
    });

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      try {
        var definition = decodedResponse['results'][0]['lexicalEntries'][0]
            ['entries'][0]['senses'][0]['definitions'][0];

        var pronunciation = decodedResponse['results'][0]['lexicalEntries'][0]
            ['entries'][0]['pronunciations'][0]['audioFile'];

        return Entry(
            word: word, definition: definition, pronunciation: pronunciation);
      } catch (e) {
        print(e);
        throw Exception(e);
      }
    } else {
      throw Exception(response.body);
    }
  }
}
