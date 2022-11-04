import 'package:flutter/cupertino.dart';

class EditingController extends ChangeNotifier {
  bool _isEditing;

  bool get isEditing => _isEditing;
  set isEditing(bool value) {
    if (_isEditing != value) {
      _isEditing = value;

      notifyListeners();
    }
  }

  EditingController([bool isEditing = false]) : _isEditing = isEditing;
}
