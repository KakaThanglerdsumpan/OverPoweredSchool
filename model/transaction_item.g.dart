// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionItemAdapter extends TypeAdapter<TransactionItem> {
  @override
  final int typeId = 1;

  @override
  TransactionItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionItem(
      className: fields[0] as String,
      courseType: fields[1] as String,
      credits: fields[2] as String,
      periods: (fields[3] as List).cast<String>(),
      periodCodes: (fields[4] as List)
          .map((dynamic e) => (e as List).cast<int>())
          .toList(),
      abbreviatedName: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.className)
      ..writeByte(1)
      ..write(obj.courseType)
      ..writeByte(2)
      ..write(obj.credits)
      ..writeByte(3)
      ..write(obj.periods)
      ..writeByte(4)
      ..write(obj.periodCodes)
      ..writeByte(5)
      ..write(obj.abbreviatedName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
