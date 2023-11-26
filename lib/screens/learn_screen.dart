import 'package:flutter/material.dart';
import 'package:my_voc/models/introduction_card.dart';
import 'package:my_voc/widgets/introduction_card_view.dart';
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
              case IntroductionCard:
                var introCard = card as IntroductionCard;
                return IntroductionCardView(introCard: introCard, index: index);
              case _:
                return Container();
            }
          },
        ),
      ),
    );
  }
}
