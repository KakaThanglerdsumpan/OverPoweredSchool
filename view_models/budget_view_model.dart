import 'package:flutter/material.dart';
import '../model/transaction_item.dart';
import '../services/local_storage_service.dart';

class BudgetViewModel extends ChangeNotifier {
  List<dynamic> getMatrix() => LocalStorageService().getScheduleMatrix();
  List<dynamic> getAvailablePeriods() =>
      LocalStorageService().getAvailablePeriods();
  List<TransactionItem> get items => LocalStorageService().getAllTransactions();

  void addItem(TransactionItem item) {
    LocalStorageService().saveTransactionItem(item);
    LocalStorageService().updateScheduleMatrix(item);
    notifyListeners();
  }

  void addSelectedPeriods(List<dynamic> periods) {
    LocalStorageService().updateAvailablePeriods(periods);
    notifyListeners();
  }

  void deleteItem(TransactionItem item) {
    final localStorage = LocalStorageService();

    localStorage.deleteTransactionItem(item);

    notifyListeners();
  }
}
