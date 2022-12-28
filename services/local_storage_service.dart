import 'package:hive_flutter/hive_flutter.dart';

import '../model/transaction_item.dart';

class LocalStorageService {
  static const String transactionsBoxKey = "transactionsBox";
  static const String availablePeriodsBoxKey = "availablePeriodsBox";

  static final LocalStorageService _instance = LocalStorageService._internal();

  factory LocalStorageService() {
    return _instance;
  }

  LocalStorageService._internal() {
    initializeHive();
  }

  Future<void> initializeHive() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TransactionItemAdapter());
    }

    await Hive.openBox<TransactionItem>(transactionsBoxKey);
    await Hive.openBox<List<dynamic>>(availablePeriodsBoxKey);
  }

  void saveTransactionItem(TransactionItem transaction) {
    Hive.box<TransactionItem>(transactionsBoxKey).add(transaction);
  }

  List<TransactionItem> getAllTransactions() {
    return Hive.box<TransactionItem>(transactionsBoxKey).values.toList();
  }

  /* for selection to stay when you are still filling out the information 
  for a class but haven't added the class yet */
  List<dynamic> getAvailablePeriods() {
    return Hive.box<List<dynamic>>(availablePeriodsBoxKey).get("periods") ??
        [
          [false, false, false, false, false], // day A
          [false, false, false, false, false], // day B
          [false, false, false, false, false], // day C
          [false, false, false, false, false], // day D
        ];
  }

  Future<void> updateAvailablePeriods(List<dynamic> newlySelectedPeriods) {
    List<dynamic> availablePeriods = getAvailablePeriods();

    for (int i = 0; i < newlySelectedPeriods.length; i++) {
      List<int> period = newlySelectedPeriods[i];
      availablePeriods[period[0]][period[1]] = true;
    }
    return Hive.box<List<dynamic>>(availablePeriodsBoxKey)
        .put("periods", availablePeriods);
  }

  Future<void> updateAvailablePeriodsAfterDelete(
      List<dynamic> newlyAvailablePeriods) {
    List<dynamic> availablePeriods = getAvailablePeriods();

    for (int i = 0; i < newlyAvailablePeriods.length; i++) {
      List<int> period = newlyAvailablePeriods[i];
      availablePeriods[period[0]][period[1]] = false;
    }
    return Hive.box<List<dynamic>>(availablePeriodsBoxKey)
        .put("periods", availablePeriods);
  }

  void deleteTransactionItem(TransactionItem classItem) {
    // Get a list of our transactions
    final transactions = Hive.box<TransactionItem>(transactionsBoxKey);
    // Create a map out of it
    final Map<dynamic, TransactionItem> map = transactions.toMap();
    dynamic desiredKey;
    // For each key in the map, we check if the transaction is the same as the one we want to delete
    map.forEach((key, value) {
      if (value.className == classItem.className) desiredKey = key;
    });

    updateAvailablePeriodsAfterDelete(classItem.periodCodes);
    // If we found the key, we delete it
    transactions.delete(desiredKey);
  }
}
