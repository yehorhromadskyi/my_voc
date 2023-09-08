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
          var textController = TextEditingController();
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  provider.history[index].definition,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                child: TextField(
                  controller: textController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 36.0),
                child: Stack(
                  children: [
                    Visibility(
                      visible: _results[index] == null,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _results[index] = textController.text ==
                                provider.history[index].word;
                          });

                          var duration = await _player
                              .setUrl(provider.history[index].pronunciation);
                          _player.play();

                          if (duration != null) {
                            await Future.delayed(duration);
                          }

                          _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease);
                        },
                        child: Text('Check'),
                      ),
                    ),
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
            ],
          );
        },
      ),
    );
  }
}
