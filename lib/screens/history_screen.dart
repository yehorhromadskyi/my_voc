import 'package:flutter/material.dart';
import 'package:my_voc/providers/search_history_provider.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    var provider = Provider.of<SearchHistoryProvider>(context, listen: false);
    await provider.loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchHistoryProvider>(
      builder: (context, provider, child) => Container(
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: provider.history.length,
          itemBuilder: (context, index) {
            return Text(
              provider.history[index].word,
              style: TextStyle(
                fontSize: 20,
              ),
            );
          },
        ),
      ),
    );
  }
}
