import 'package:hive/hive.dart';

part 'product_model.g.dart';


@HiveType(typeId: 0)
class Product {
  @HiveField(0)
  String name;

  @HiveField(1)
  int quantity;

  @HiveField(2)
  double rate;

  Product({
    required this.name,
    required this.quantity,
    required this.rate,
  });

  double get total => quantity * rate;
}