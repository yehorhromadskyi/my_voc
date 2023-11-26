import 'package:flutter/material.dart';
import 'package:my_voc/models/shadow_typing_card.dart';
import 'package:my_voc/providers/learn_screen_provider.dart';
import 'package:provider/provider.dart';

class ShadowTypingCardView extends StatelessWidget {
  const ShadowTypingCardView(
      {super.key, required this.index, required this.card});

  final int index;
  final ShadowTypingCard card;

  @override
  Widget build(BuildContext context) {
    return Consumer<LearnScreenProvider>(
      builder: (context, provider, child) => Container(
        child: Column(
          children: [Text(card.definition)],
        ),
      ),
    );
  }
}
