// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveDataAdapter extends TypeAdapter<HiveData> {
  @override
  final int typeId = 0;

  @override
  HiveData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveData(
      name: fields[0] as String,
      json: fields[2] as String,
      date: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HiveData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.json);
  }
}
