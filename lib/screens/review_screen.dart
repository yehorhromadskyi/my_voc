import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_voc/providers/search_history_provider.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final PageController _pageController = PageController();
  final AudioPlayer _player = AudioPlayer();

  final HashMap<int, bool> _results = HashMap();

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchHistoryProvider>(
      builder: (context, provider, child) => PageView.builder(
        controller: _pageController,
        itemCount: provider.history.length,
        itemBuilder: (context, index) {
          var currentEntry = provider.history[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50.0,
                height: 50.0,
                child: Stack(
                  children: [
                    Visibility(
                      visible: _results[index] ?? false,
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                    Visibility(
                      visible: (_results[index] ?? true) ? false : true,
                      child: Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
                child: Text(
                  currentEntry.definition,
                  textAlign: TextAlign.center,
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: List.generate(
                  currentEntry.word.length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(left: 6.0, bottom: 8.0),
                    child: SizedBox(
                      width: 20.0,
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                              currentEntry.guess[i],
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              Wrap(
                children: List.generate(
                  currentEntry.shuffled.length,
                  (i) {
                    var firstEmpty = currentEntry.guess.indexOf('');

                    return Padding(
                      padding: const EdgeInsets.only(left: 6.0, bottom: 8.0),
                      child: ElevatedButton(
                        onPressed: currentEntry.sequence.contains(i)
                            ? null
                            : () {
                                setState(() {
                                  currentEntry.guess[firstEmpty] =
                                      currentEntry.shuffled[i];

                                  currentEntry.sequence.add(i);
                                });
                              },
                        child: Text(
                          currentEntry.shuffled[i],
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _results[index] =
                              currentEntry.guess.join().toLowerCase() ==
                                  currentEntry.word.toLowerCase();
                        });

                        var duration =
                            await _player.setUrl(currentEntry.pronunciation);
                        _player.play();

                        if (duration != null) {
                          await Future.delayed(duration);
                        }

                        _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                      child: Icon(Icons.keyboard_return),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          var firstEmpty = currentEntry.guess.indexOf('');
                          if (firstEmpty == -1) {
                            firstEmpty = currentEntry.guess.length;
                          }
                          currentEntry.guess[firstEmpty - 1] = '';
                          currentEntry.sequence.removeLast();
                        });
                      },
                      child: Icon(Icons.backspace_outlined),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
