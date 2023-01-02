import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'class_item.g.dart'; // Make sure to include this

@HiveType(typeId: 1)
class ClassItem {
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
  @HiveField(5)
  String courseType;
  @HiveField(6)
  String credit;
  @HiveField(7)
  String grade;
  ClassItem(
      {required this.className,
      required this.periods,
      required this.periodCodes,
      required this.abbreviatedName,
      required this.colorIndex,
      this.courseType = '0',
      this.credit = '0',
      this.grade = '0',
      Key? key});
}
