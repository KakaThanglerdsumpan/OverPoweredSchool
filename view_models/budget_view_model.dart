import 'package:flutter/material.dart';
import '../model/transaction_item.dart';
import '../services/local_storage_service.dart';

class BudgetViewModel extends ChangeNotifier {
  List<List<bool>> getAvailablePeriods() =>
      LocalStorageService().getAvailablePeriods();
  List<TransactionItem> get items => LocalStorageService().getAllTransactions();

  void addItem(TransactionItem item) {
    LocalStorageService().saveTransactionItem(item);
    notifyListeners();
  }

  void addSelectedPeriods(List<List<int>> periods) {
    LocalStorageService().updateAvailablePeriods(periods);
    notifyListeners();
  }

  void deleteItem(TransactionItem item) {
    final localStorage = LocalStorageService();

    localStorage.deleteTransactionItem(item);

    notifyListeners();
  }
}
