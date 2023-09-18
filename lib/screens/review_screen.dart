import 'package:flutter/material.dart';
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context_) => ChangeNotifierProvider(
                        create: (context_) {
                          var databaseService = Provider.of<DatabaseService>(
                              context,
                              listen: false);
                          return ShuffleReviewScreenProvider(databaseService);
                        },
                        child: ShuffleReviewScreen()),
                  ));
            },
            child: Text('Shuffle review'))
      ],
    );
  }
}
