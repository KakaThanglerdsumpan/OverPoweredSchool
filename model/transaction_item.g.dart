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
      itemTitle: fields[0] as String,
      courseType: fields[1] as String,
      credits: fields[2] as String,
      periods: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, TransactionItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.itemTitle)
      ..writeByte(1)
      ..write(obj.courseType)
      ..writeByte(2)
      ..write(obj.credits)
      ..writeByte(3)
      ..write(obj.periods);
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
