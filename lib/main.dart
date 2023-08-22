import 'package:flutter/material.dart';
import 'package:my_voc/providers/api_service_provider.dart';
import 'package:my_voc/providers/search_history_provider.dart';
import 'package:my_voc/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SearchHistoryProvider()),
          ChangeNotifierProvider(create: (_) => ApiServiceProvider())
        ],
        child: HomeScreen(),
      ),
    );
  }
}
