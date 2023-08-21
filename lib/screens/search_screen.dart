import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:my_voc/models/search_history_model.dart';
import 'package:my_voc/secrets.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _wordController = TextEditingController();
  AudioPlayer player = AudioPlayer();

  String _definition = '';
  String _pronunciation = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchHistoryModel>(
      builder: (context, value, child) => Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    var duration = await player.setUrl(_pronunciation);
                    player.play();
                  },
                  child: Icon(
                    Icons.volume_up_rounded,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _wordController,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    var url =
                        'https://od-api.oxforddictionaries.com/api/v2/entries/en/${_wordController.text}';

                    var response = await http.get(Uri.parse(url), headers: {
                      'app_id': kAppId,
                      'app_key': kAppKey,
                    });

                    if (response.statusCode == 200) {
                      var decodedResponse = jsonDecode(response.body);
                      try {
                        var definition = decodedResponse['results'][0]
                                ['lexicalEntries'][0]['entries'][0]['senses'][0]
                            ['definitions'][0];

                        _pronunciation = decodedResponse['results'][0]
                                ['lexicalEntries'][0]['entries'][0]
                            ['pronunciations'][0]['audioFile'];

                        value.add(_wordController.text);

                        setState(() {
                          _definition = definition;
                        });
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: Icon(Icons.search),
                ),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            Text(_definition),
          ],
        ),
      ),
    );
  }
}
