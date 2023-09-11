import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_voc/providers/search_screen_provider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _wordController = TextEditingController();
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    var provider = Provider.of<SearchScreenProvider>(context, listen: false);
    await provider.loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchScreenProvider>(
      builder: (context, provider, child) => Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    if (provider.selectedEntry != null) {
                      await player
                          .setUrl(provider.selectedEntry!.pronunciation);
                      player.play();
                    }
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
                    final entry = await provider.get(_wordController.text);
                    provider.selectedEntry = entry;
                  },
                  child: Icon(Icons.search),
                ),
              ],
            ),
            SizedBox(
              height: 40.0,
            ),
            Text(
              provider.selectedEntry?.definition ?? '',
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
                        provider.selectedEntry = entry;
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
