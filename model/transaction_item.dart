import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'transaction_item.g.dart';

@HiveType(typeId: 1)
class TransactionItem {
  @HiveField(0)
  String className;
  @HiveField(1)
  List<String> periods;
  @HiveField(2)
  List<dynamic> periodCodes;
  @HiveField(3)
  String abbreviatedName;
  @HiveField(4)
  int colorIndex;
  TransactionItem({
    required this.className,
    required this.periods,
    required this.periodCodes,
    required this.abbreviatedName,
    required this.colorIndex,
  });
}
