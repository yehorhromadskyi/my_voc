import 'package:flutter/material.dart';
import 'package:my_voc/models/introduction_card.dart';
import 'package:my_voc/providers/learn_screen_provider.dart';
import 'package:provider/provider.dart';

class IntroductionCardView extends StatelessWidget {
  const IntroductionCardView({
    super.key,
    required this.card,
  });

  final IntroductionCard card;

  @override
  Widget build(BuildContext context) {
    return Consumer<LearnScreenProvider>(
      builder: (context, provider, child) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 18.0,
                    top: 18.0,
                  ),
                  child: Text(
                    card.word,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                SizedBox(
                  width: 4.0,
                ),
                GestureDetector(
                  onTap: () {
                    provider.pronounce(card);
                  },
                  child: Icon(Icons.volume_up_rounded),
                )
              ],
            ),
            SizedBox.fromSize(
              size: Size.fromHeight(8),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                card.definition,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox.fromSize(
              size: Size.fromHeight(24),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: Column(
                    children: List.generate(
                      card.examples.length,
                      (index) => Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha(50),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        child: Text(
                          card.examples[index],
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
