import 'package:flutter/material.dart';
import 'package:my_voc/models/search_history_model.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchHistoryModel>(
      builder: (context, value, child) => Container(
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: value.history.length,
          itemBuilder: (BuildContext context, int index) {
            return Text(value.history[index]);
          },
        ),
      ),
    );
  }
}