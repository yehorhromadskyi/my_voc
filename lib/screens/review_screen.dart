import 'package:flutter/material.dart';
import 'package:my_voc/providers/learn_screen_provider.dart';
import 'package:my_voc/screens/learn_screen.dart';
import 'package:my_voc/screens/shuffle_review_screen.dart';
import 'package:provider/provider.dart';

import '../providers/shuffle_review_screen_provider.dart';
import '../services/database_service.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(),
          flex: 20,
        ),
        Expanded(
          flex: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 40.0,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context_) => ChangeNotifierProvider(
                                create: (context_) {
                                  var databaseService =
                                      Provider.of<DatabaseService>(context,
                                          listen: false);
                                  return ShuffleReviewScreenProvider(
                                      databaseService);
                                },
                                child: ShuffleReviewScreen()),
                          ));
                    },
                    child: Text('Shuffle review')),
              ),
              SizedBox(
                height: 12.0,
              ),
              Container(
                height: 40.0,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context_) => ChangeNotifierProvider(
                              create: (context_) {
                                var databaseService =
                                    Provider.of<DatabaseService>(context,
                                        listen: false);
                                return LearnScreenProvider(databaseService);
                              },
                              child: LearnScreen(),
                            ),
                          ));
                    },
                    child: Text('Learn new words')),
              ),
            ],
          ),
        ),
        Expanded(
          child: SizedBox(),
          flex: 20,
        ),
      ],
    );
  }
}
