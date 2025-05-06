// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookmarkAdapter extends TypeAdapter<Bookmark> {
  @override
  final int typeId = 0;

  @override
  Bookmark read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bookmark(
      arabicText: fields[0] as String,
      englishText: fields[1] as String,
      verseIndex: fields[2] as int,
      rukuNumber: fields[3] as int,
      date: fields[4] as String,
      title: fields[5] as String,
      iconType: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Bookmark obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.arabicText)
      ..writeByte(1)
      ..write(obj.englishText)
      ..writeByte(2)
      ..write(obj.verseIndex)
      ..writeByte(3)
      ..write(obj.rukuNumber)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.iconType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
