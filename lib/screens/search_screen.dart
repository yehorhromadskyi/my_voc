import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_voc/providers/api_service_provider.dart';
import 'package:my_voc/providers/search_history_provider.dart';
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
    return Consumer<SearchHistoryProvider>(
      builder: (context, provider, child) => Container(
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
                    final apiServiceProvider =
                        Provider.of<ApiServiceProvider>(context, listen: false);
                    var entry = await apiServiceProvider.apiService
                        .getEntry(_wordController.text);
                    provider.add(entry);
                    _pronunciation = entry.pronunciation;

                    setState(() {
                      _definition = entry.definition;
                    });
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
