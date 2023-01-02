import 'package:flutter/material.dart';
import '../model/class_item.dart';
import '../services/local_storage_service.dart';

class BudgetViewModel extends ChangeNotifier {
  List<dynamic> getMatrix() => LocalStorageService().getScheduleMatrix();
  List<dynamic> getAvailablePeriods() =>
      LocalStorageService().getAvailablePeriods();
  List<ClassItem> get items => LocalStorageService().getAllTransactions();

  void addItem(ClassItem item) {
    LocalStorageService().saveClassItem(item);
    LocalStorageService().updateScheduleMatrix(item);
    notifyListeners();
  }

  void editClassInfo(ClassItem updatedClass, int index) {
    LocalStorageService().updateClassInfo(updatedClass, index);
    notifyListeners();
  }

  void addSelectedPeriods(List<dynamic> periods) {
    LocalStorageService().updateAvailablePeriods(periods);
    notifyListeners();
  }

  void deleteItem(ClassItem item) {
    final localStorage = LocalStorageService();

    localStorage.deleteClassItem(item);

    notifyListeners();
  }
}
