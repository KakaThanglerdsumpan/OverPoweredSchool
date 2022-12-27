import 'package:flutter/material.dart';

class PeriodSelectionService extends ChangeNotifier {
  List<String> _periods = [];

  List<List<int>> _periodCodes = [];

  List<List<bool>> _isPeriosSelectedTMP = [
    [false, false, false, false, false],
    [false, false, false, false, false],
    [false, false, false, false, false],
    [false, false, false, false, false],
  ];

  List<String> get periods => _periods;

  List<List<int>> get periodCodes => _periodCodes;

  List<List<bool>> get isPeriodSelectedTMP => _isPeriosSelectedTMP;

  set periods(List<String> selection) {
    _periods = selection;
    notifyListeners();
  }

  set periodCodes(List<List<int>> selection) {
    _periodCodes = selection;
    notifyListeners();
  }

  set isPeriodSelectedTMP(List<List<bool>> selection) {
    _isPeriosSelectedTMP = selection;
    notifyListeners();
  }
}
