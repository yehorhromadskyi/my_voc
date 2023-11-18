import 'package:flutter/material.dart';
import 'package:my_voc/models/introduction_card.dart';
import 'package:my_voc/models/multiple_options_card.dart';
import 'package:provider/provider.dart';

import '../providers/learn_screen_provider.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    var provider = Provider.of<LearnScreenProvider>(context, listen: false);
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
      body: Consumer<LearnScreenProvider>(
        builder: (context, provider, child) => PageView.builder(
          itemCount: provider.cards.length,
          onPageChanged: (page) {
            provider.play(page);
          },
          itemBuilder: (context, index) {
            var card = provider.cards[index];
            switch (card.runtimeType) {
              case MultipleOptionsCard:
                return Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 18.0,
                              top: 18.0,
                            ),
                            child: Text(
                              provider.cards[index].word,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 36,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              provider.play(index);
                            },
                            child: Icon(Icons.volume_up_rounded),
                          )
                        ],
                      )
                    ],
                  ),
                );
              case IntroductionCard:
                return Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 18.0,
                              top: 18.0,
                            ),
                            child: Text(
                              provider.cards[index].word,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 36,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              provider.play(index);
                            },
                            child: Icon(Icons.volume_up_rounded),
                          )
                        ],
                      )
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
