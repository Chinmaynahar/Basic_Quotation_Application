// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuoteAdapter extends TypeAdapter<Quote> {
  @override
  final int typeId = 2;

  @override
  Quote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quote(
      client: fields[0] as Client,
      products: (fields[1] as List).cast<Product>(),
      discount: fields[2] as double,
      tax: fields[3] as double,
      isTaxInclusive: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Quote obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.client)
      ..writeByte(1)
      ..write(obj.products)
      ..writeByte(2)
      ..write(obj.discount)
      ..writeByte(3)
      ..write(obj.tax)
      ..writeByte(4)
      ..write(obj.isTaxInclusive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
