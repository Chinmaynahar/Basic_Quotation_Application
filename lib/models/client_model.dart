import 'package:hive/hive.dart';

part 'client_model.g.dart';

@HiveType(typeId: 1)
class Client {
  @HiveField(0)
  String name;

  @HiveField(1)
  String address;

  @HiveField(2)
  String reference;

  Client({
    required this.name,
    required this.address,
    required this.reference,
  });
}
