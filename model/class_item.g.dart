// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassItemAdapter extends TypeAdapter<ClassItem> {
  @override
  final int typeId = 1;

  @override
  ClassItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassItem(
      className: fields[0] as String,
      periods: (fields[1] as List).cast<String>(),
      periodCodes: (fields[2] as List).cast<dynamic>(),
      abbreviatedName: fields[3] as String,
      colorIndex: fields[4] as int,
      courseType: fields[5] as String,
      credit: fields[6] as String,
      grade: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClassItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.className)
      ..writeByte(1)
      ..write(obj.periods)
      ..writeByte(2)
      ..write(obj.periodCodes)
      ..writeByte(3)
      ..write(obj.abbreviatedName)
      ..writeByte(4)
      ..write(obj.colorIndex)
      ..writeByte(5)
      ..write(obj.courseType)
      ..writeByte(6)
      ..write(obj.credit)
      ..writeByte(7)
      ..write(obj.grade);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
