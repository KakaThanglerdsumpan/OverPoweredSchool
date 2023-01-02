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
      periods: (fields[1] as List).cast<String>(),
      periodCodes: (fields[2] as List).cast<dynamic>(),
      abbreviatedName: fields[3] as String,
      colorIndex: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.className)
      ..writeByte(1)
      ..write(obj.periods)
      ..writeByte(2)
      ..write(obj.periodCodes)
      ..writeByte(3)
      ..write(obj.abbreviatedName)
      ..writeByte(4)
      ..write(obj.colorIndex);
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
