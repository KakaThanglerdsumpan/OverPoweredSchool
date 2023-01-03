import 'package:hive_flutter/hive_flutter.dart';
import 'package:opschooldraft1/free_block.dart';

import '../model/class_item.dart';

class LocalStorageService {
//---- Declare box keys ----{{
  static const String transactionsBoxKey = "transactionsBox";
  static const String availablePeriodsBoxKey = "availablePeriodsBox";
  static const String scheduleMatrixBoxKey = "scheduleMatrixBox";
//---- Declare box keys ----}}

  static final LocalStorageService _instance = LocalStorageService._internal();

  factory LocalStorageService() {
    return _instance;
  }

  LocalStorageService._internal() {
    initializeHive();
  }

//---- Initialize Hive ----{{
  Future<void> initializeHive() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ClassItemAdapter());
    }

    await Hive.openBox<ClassItem>(transactionsBoxKey);
    await Hive.openBox<List<dynamic>>(availablePeriodsBoxKey);
    await Hive.openBox<List<dynamic>>(scheduleMatrixBoxKey);
  }
//---- Initialize Hive ---}}

//---- Handling Class Items ----{{
  // add new class to box
  void saveClassItem(ClassItem transaction) {
    Hive.box<ClassItem>(transactionsBoxKey).add(transaction);
  }

  // get list of classes currently in box
  List<ClassItem> getAllTransactions() {
    return Hive.box<ClassItem>(transactionsBoxKey).values.toList();
  }
//---- Handling Class Items ----}}

//---- Handling Schedule ----{{
  List<dynamic> getAvailablePeriods() {
    return Hive.box<List<dynamic>>(availablePeriodsBoxKey).get("periods") ??
        [
          [false, false, false, false, false], // day A
          [false, false, false, false, false], // day B
          [false, false, false, false, false], // day C
          [false, false, false, false, false], // day D
        ];
  }

  List<dynamic> getScheduleMatrix() {
    return Hive.box<List<dynamic>>(scheduleMatrixBoxKey).get("matrix") ??
        [
          [freeBlock, freeBlock, freeBlock, freeBlock, freeBlock], // day A
          [freeBlock, freeBlock, freeBlock, freeBlock, freeBlock], // day B
          [freeBlock, freeBlock, freeBlock, freeBlock, freeBlock], // day C
          [freeBlock, freeBlock, freeBlock, freeBlock, freeBlock], // day D
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

  Future<void> updateScheduleMatrix(ClassItem newClass) {
    List<dynamic> currentMatrix = getScheduleMatrix();

    List<dynamic> periods = newClass.periodCodes;

    for (int i = 0; i < periods.length; i++) {
      List<int> period = periods[i];
      currentMatrix[period[0]][period[1]] = newClass;
    }
    return Hive.box<List<dynamic>>(scheduleMatrixBoxKey)
        .put("matrix", currentMatrix);
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

  Future<void> updateMatrixAfterDelete(List<dynamic> nowFreePeriods) {
    List<dynamic> matrix = getScheduleMatrix();

    for (int i = 0; i < nowFreePeriods.length; i++) {
      List<int> period = nowFreePeriods[i];
      matrix[period[0]][period[1]] = freeBlock;
    }
    return Hive.box<List<dynamic>>(scheduleMatrixBoxKey).put("matrix", matrix);
  }
  //---- Handling Schedule ----}}

  Future<void> updateClassInfo(ClassItem updatedClass, int index) {
    return Hive.box<ClassItem>(transactionsBoxKey).putAt(index, updatedClass);
  }

  void deleteClassItem(ClassItem classItem) {
    // Get a list of our transactions
    final transactions = Hive.box<ClassItem>(transactionsBoxKey);
    // Create a map out of it
    final Map<dynamic, ClassItem> map = transactions.toMap();
    dynamic desiredKey;
    // For each key in the map, we check if the transaction is the same as the one we want to delete
    map.forEach((key, value) {
      if (value.className == classItem.className) desiredKey = key;
    });

    updateAvailablePeriodsAfterDelete(classItem.periodCodes);
    updateMatrixAfterDelete(classItem.periodCodes);
    // If we found the key, we delete it
    transactions.delete(desiredKey);
  }
}
