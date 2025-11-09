
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quote_builder/models/product_model.dart';
import 'package:quote_builder/models/client_model.dart';
import 'package:quote_builder/models/quote_model.dart';

class HiveService {
  static const String quoteBoxName = 'QuotationBox';

  static Future<void> initHive() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(ProductAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ClientAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(QuoteAdapter());

    await Hive.openBox<Quote>(quoteBoxName);
  }

  static Box<Quote> getQuoteBox() {
    return Hive.box<Quote>(quoteBoxName);
  }

  static Future<void> addQuote(Quote quote) async {
    final box = getQuoteBox();
    await box.add(quote);
  }

  static List<Quote> getAllQuotes() {
    final box = getQuoteBox();
    return box.values.cast<Quote>().toList();
  }
  static Future<void> deleteQuote(int index) async {
    final box = getQuoteBox();
    await box.deleteAt(index);
  }
}

