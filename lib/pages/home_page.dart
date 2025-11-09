import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quote_builder/pages/quote_editor.dart';
import 'package:quote_builder/services/hive_service.dart';
import 'package:quote_builder/models/quote_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final box = HiveService.getQuoteBox();
  List<Quote> quotes = HiveService.getAllQuotes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: ValueListenableBuilder<Box<Quote>>(
        valueListenable: box.listenable(),
        builder: (context, Box<Quote> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No quotes saved yet.'));
          }

          // 🔹 No Expanded here
          return ListView.builder(
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              final quote = quotes[index];
              return ListTile(
                title: Text('Quote ${index + 1} - ${quote.client.name}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await HiveService.deleteQuote(index);
                    setState(() {
                      quotes = HiveService.getAllQuotes();
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QuoteEditor()),
          ).then((_) {
            // 🔹 Refresh after returning from QuoteEditor
            setState(() {
              quotes = HiveService.getAllQuotes();
            });
          });
        },
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
