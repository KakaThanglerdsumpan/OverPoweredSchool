import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'transaction_item.g.dart';

@HiveType(typeId: 1)
class TransactionItem {
  @HiveField(0)
  String className;
  @HiveField(1)
  String courseType;
  @HiveField(2)
  String credits;
  @HiveField(3)
  List<String> periods;
  @HiveField(4)
  List<dynamic> periodCodes;
  @HiveField(5)
  String abbreviatedName;
  @HiveField(6)
  @HiveType(typeId: 2)
  int colorIndex;
  TransactionItem({
    required this.className,
    required this.courseType,
    required this.credits,
    required this.periods,
    required this.periodCodes,
    required this.abbreviatedName,
    required this.colorIndex,
  });
}
