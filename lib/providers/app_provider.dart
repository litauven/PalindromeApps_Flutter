import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  String _userName = '';
  String _selectedUserName = '';

  String get userName => _userName;
  String get selectedUserName => _selectedUserName;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setSelectedUserName(String name) {
    _selectedUserName = name;
    notifyListeners();
  }
}
