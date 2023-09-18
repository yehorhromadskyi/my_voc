import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../providers/shuffle_review_screen_provider.dart';

class ShuffleReviewScreen extends StatefulWidget {
  const ShuffleReviewScreen({super.key});

  @override
  State<ShuffleReviewScreen> createState() => _ShuffleReviewScreenState();
}

class _ShuffleReviewScreenState extends State<ShuffleReviewScreen> {
  final PageController _pageController = PageController();
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    var provider =
        Provider.of<ShuffleReviewScreenProvider>(context, listen: false);
    await provider.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Consumer<ShuffleReviewScreenProvider>(
        builder: (context, provider, child) => Column(
          children: [
            LinearProgressIndicator(
              value: provider.progress,
            ),
            Expanded(
              child: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                itemCount: provider.forReview.length,
                itemBuilder: (context, index) {
                  var currentEntry = provider.forReview[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50.0,
                        height: 50.0,
                        child: Center(
                          child: Stack(
                            children: [
                              Visibility(
                                visible: provider.results[index] ?? false,
                                child: Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                              ),
                              Visibility(
                                visible: (provider.results[index] ?? true)
                                    ? false
                                    : true,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 24.0, right: 24.0, bottom: 24.0),
                        child: Text(
                          currentEntry.definition,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 6.0,
                        runSpacing: 8.0,
                        children: List.generate(
                          currentEntry.word.length,
                          (i) => SizedBox(
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
                      SizedBox(height: 24.0),
                      Wrap(
                        spacing: 6.0,
                        runSpacing: 8.0,
                        children: List.generate(
                          currentEntry.shuffled.length,
                          (i) {
                            var firstEmpty = currentEntry.guess.indexOf('');

                            return ElevatedButton(
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
                                provider.check(index);

                                Duration? duration;

                                if (currentEntry
                                        .cachedPronunciation?.isNotEmpty ??
                                    false) {
                                  duration = await _player.setFilePath(
                                      currentEntry.cachedPronunciation!);
                                } else {
                                  duration = await _player
                                      .setUrl(currentEntry.pronunciation);
                                }

                                _player.play();

                                if (duration != null) {
                                  await Future.delayed(duration);
                                }

                                if (provider.progress < 1) {
                                  _pageController.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.ease);
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              child: Icon(Icons.keyboard_return),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  var firstEmpty =
                                      currentEntry.guess.indexOf('');
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
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
