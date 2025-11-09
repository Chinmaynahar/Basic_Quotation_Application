import 'package:flutter/material.dart';
import 'package:quote_builder/components/bottom_summary_bar.dart';
import 'package:quote_builder/models/product_model.dart';
import 'package:quote_builder/models/quote_model.dart';
import 'package:quote_builder/models/client_model.dart';
import 'package:quote_builder/pages/Forms/client_form.dart';
import 'package:quote_builder/pages/Forms/product_form.dart';

class QuoteEditor extends StatefulWidget {
  const QuoteEditor({super.key});

  @override
  State<QuoteEditor> createState() => _QuoteEditorState();
}

class _QuoteEditorState extends State<QuoteEditor> {
   Client client = Client(name: 'Unnamed', address: '', reference: '');
  List<Product> products = [];
  Quote? quote;
  double get subtotal {
    return products.fold(0, (sum, item) => sum + (item.rate * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quote Editor')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🧾 Client Section
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.grey[200],
                child: Row(
                  children: [
                    Text('Client: ${client.name}'),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () async {
                        final newClient = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddClientPage(
                              client: client,
                            ),
                          ),
                        );

                        if (newClient != null && newClient is Client) {
                          setState(() {
                            client = newClient;
                          });
                        }
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),

              // 🛒 Products Section
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.grey[200],
                child: Row(
                  children: [
                    const Text('Products:'),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () async {
                        final newProduct = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddProductPage(
                              product: Product(name: '', rate: 0, quantity: 0),
                            ),
                          ),
                        );

                        if (newProduct != null && newProduct is Product) {
                          setState(() {
                            products.add(newProduct);
                          });
                        }
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              ...products.map(
                (product) => GestureDetector(
                  onTap: () async {
                    Product updatedProduct = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddProductPage(product: product),
                      ),
                    );
                    setState(() {
                      final index = products.indexOf(product);
                      products[index] = updatedProduct;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(product.name),
                        Text(
                          '${product.quantity} x ₹${product.rate.toStringAsFixed(2)}',
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              products.remove(product);
                            });
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomSummaryBar(
        subtotal: subtotal,
        discount: quote?.discount ?? 0,
        tax: quote?.tax ?? 0,
        isTaxInclusive: false,
        quote: quote ??
            Quote(
              client: client,
              products: products,
              tax: 0,
              discount: 0,
              isTaxInclusive: false
            ),
        onValuesChanged: (discount, tax, isTaxInclusive) {
          setState(() {
            quote = Quote(
              client: quote?.client ?? client,
              products: quote?.products ?? products,
              tax: tax,
              discount: discount,
              isTaxInclusive: isTaxInclusive
            );
          });
        },
      ),
    );
  }
}
