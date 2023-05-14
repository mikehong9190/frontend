import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String _userId = '';
  String _emailId = '';
  bool isManuallySignedIn = true;

  String get  userId => _userId;
  String get emailId => _emailId;
  void setUserDetails ( {required String userId,required String emailId,required String message}) {
      _userId = userId;
      _emailId = emailId;
      isManuallySignedIn = !message.toString().toLowerCase().contains ("google");
      notifyListeners();
  }
}