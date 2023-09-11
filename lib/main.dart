import 'package:flutter/material.dart';
import 'package:my_voc/providers/search_screen_provider.dart';
import 'package:my_voc/screens/home_screen.dart';
import 'package:my_voc/services/api_service.dart';
import 'package:my_voc/services/database_service.dart';
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
          Provider<DatabaseService>(create: (_) => DatabaseService()),
          Provider<ApiService>(create: (_) => ApiService()),
          ChangeNotifierProvider(
            create: (context) {
              var databaseService =
                  Provider.of<DatabaseService>(context, listen: false);
              var apiService = Provider.of<ApiService>(context, listen: false);
              return SearchScreenProvider(databaseService, apiService);
            },
          ),
        ],
        child: HomeScreen(),
      ),
    );
  }
}
