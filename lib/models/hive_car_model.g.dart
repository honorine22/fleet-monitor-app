// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_car_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveCarModelAdapter extends TypeAdapter<HiveCarModel> {
  @override
  final int typeId = 0;

  @override
  HiveCarModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveCarModel(
      id: fields[0] as String,
      name: fields[1] as String,
      latitude: fields[2] as double,
      longitude: fields[3] as double,
      speed: fields[4] as double,
      status: fields[5] as String,
      lastUpdated: fields[6] as DateTime,
      route: (fields[7] as List).cast<HiveLatLng>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveCarModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longitude)
      ..writeByte(4)
      ..write(obj.speed)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.lastUpdated)
      ..writeByte(7)
      ..write(obj.route);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveCarModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveLatLngAdapter extends TypeAdapter<HiveLatLng> {
  @override
  final int typeId = 1;

  @override
  HiveLatLng read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveLatLng(
      fields[0] as double,
      fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, HiveLatLng obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveLatLngAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
