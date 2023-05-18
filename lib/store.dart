import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';

class User with ChangeNotifier {
  bool userLoggedIn = false;
  String _userId = '';
  String _emailId = '';
  bool isManuallySignedIn = true;
  String _profilePicture = '';
  String get userId => _userId;
  String get emailId => _emailId;
  String get profilePicture => _profilePicture;

  final List<XFile> _images = [];
  List<XFile> get images => _images;

  void addImage(XFile image) {
    _images.add(image);
    notifyListeners();
  }

  void removeImage(XFile image) {
    _images.remove(image);
    notifyListeners();
  }

  void clearImages() {
    _images.clear();
    notifyListeners();
  }

  void setUserDetails(
      {required String userId,
      required String emailId,
      required String message}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('profilePicture', profilePicture);
    print(userId);
    print(emailId);
    print(message);
    prefs.setString('userId', userId);
    prefs.setString('emailId', emailId);
    prefs.setBool('userLoggedIn', userId.isNotEmpty);
    prefs.setBool('isManuallySignedIn',
        !message.toString().toLowerCase().contains("google"));

    _profilePicture = profilePicture;
    _userId = userId;
    userLoggedIn = userId.isNotEmpty;
    _emailId = emailId;
    isManuallySignedIn = !message.toString().toLowerCase().contains("google");
    notifyListeners();
  }

  void clearUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('emailId');
    await prefs.remove('userLoggedIn');
    await prefs.remove('isManuallySignedIn');

    _userId = '';
    userLoggedIn = false;
    _emailId = '';
    isManuallySignedIn = false;
    notifyListeners();
  }

  void getUserDataFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId')!;
    // _profilePicture = prefs.getString('profilePicture');
    userLoggedIn = prefs.getBool('userLoggedIn')!;
    _emailId = prefs.getString('emailId')!;
    isManuallySignedIn = prefs.getBool('isManuallySignedIn')!;
    notifyListeners();
  }
}
