import 'package:flutter/material.dart';
import 'package:my_voc/services/api_service.dart';

class ApiServiceProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  ApiService get apiService => _apiService;
}
