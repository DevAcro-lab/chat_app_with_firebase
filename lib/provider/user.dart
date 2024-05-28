import 'package:flutter/material.dart';

import '../service/user_service.dart';

class UserNotifier with ChangeNotifier {
  final UserService _userService = UserService();
  bool isLoading = false;
  List<Map<String, dynamic>>? userList;

  void toggleLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void fetchAllUsersExceptCurrent() async {
    toggleLoading(true);
    userList = await _userService.fetchAllUsersExceptCurrentUser();
    notifyListeners();
    toggleLoading(false);
  }
}
