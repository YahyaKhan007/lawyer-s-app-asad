import 'package:flutter/foundation.dart';

class Loading extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  changeLoading({required bool status}) {
    _loading = status;
    notifyListeners();
  }
}
