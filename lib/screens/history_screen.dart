import 'package:flutter/material.dart';
import 'package:my_voc/providers/search_history_provider.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchHistoryProvider>(
      builder: (context, provider, child) => Container(
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              height: 0,
            );
          },
          itemCount: provider.history.length,
          itemBuilder: (context, index) {
            final entry = provider.history[index];
            return Dismissible(
              key: Key(entry.id.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                child: Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 18.0,
                    ),
                  ),
                ),
                color: Colors.red,
              ),
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  provider.remove(entry);
                }
              },
              child: ListTile(
                title: Container(
                  child: Text(
                    provider.history[index].word,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
