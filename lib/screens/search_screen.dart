import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_voc/models/entry.dart' as models;
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
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    var provider = Provider.of<SearchHistoryProvider>(context, listen: false);
    await provider.loadHistory();
  }

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
                    await player.setUrl(_pronunciation);
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
                    models.Entry entry;
                    final existing = await provider.get(_wordController.text);
                    if (existing.isEmpty) {
                      final apiServiceProvider =
                          Provider.of<ApiServiceProvider>(context,
                              listen: false);
                      entry = await apiServiceProvider.apiService
                          .getEntry(_wordController.text);

                      provider.add(entry);
                    } else {
                      entry = existing.first;
                    }

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
              height: 40.0,
            ),
            Text(
              _definition,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40.0,
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 0,
                  );
                },
                itemCount: provider.history.length,
                itemBuilder: (context, index) {
                  final entry = provider.history[index];
                  return Dismissible(
                    key: Key(entry.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 18.0,
                          ),
                        ),
                      ),
                      color: Colors.red,
                    ),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        provider.remove(entry);
                      }
                    },
                    child: GestureDetector(
                      onTap: () {
                        _wordController.text = entry.word;
                        _pronunciation = entry.pronunciation;
                        setState(() {
                          _definition = entry.definition;
                        });
                      },
                      child: ListTile(
                        title: Container(
                          child: Text(
                            provider.history[index].word,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
