import 'package:hive/hive.dart';
part 'transaction_item.g.dart';

@HiveType(typeId: 1)
class TransactionItem {
  @HiveField(0)
  String itemTitle;
  @HiveField(1)
  String courseType;
  @HiveField(2)
  String credits;
  @HiveField(3)
  List<String> periods;
  TransactionItem(
      {required this.itemTitle,
      required this.courseType,
      required this.credits,
      required this.periods});
}
