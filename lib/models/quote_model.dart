import 'package:quote_builder/models/product_model.dart';
import 'package:quote_builder/models/client_model.dart';
import 'package:hive/hive.dart';

part 'quote_model.g.dart';

@HiveType(typeId: 2)
class Quote {
  @HiveField(0)
  Client client;

  @HiveField(1)
  List<Product> products;

  @HiveField(2)
  double discount;

  @HiveField(3)
  double tax;

  @HiveField(4)
  bool isTaxInclusive;

  Quote({
    required this.client,
    required this.products,
    required this.discount,
    required this.tax,
    required this.isTaxInclusive,
  });

 double get subtotal =>
      products.fold(0.0, (sum, item) => sum + item.total);

  double get grandTotal {
    double total = subtotal - discount;
    if (isTaxInclusive) total += (subtotal * tax / 100);
    return total;
  }
   double get taxAmount {
    if (isTaxInclusive) {
      return (subtotal * tax / 100);
    } else {
      return ((subtotal - (discount)) * tax / 100);
    }
  }
}
