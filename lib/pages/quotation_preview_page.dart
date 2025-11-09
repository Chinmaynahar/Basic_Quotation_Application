import 'package:flutter/material.dart';
import 'package:quote_builder/models/quote_model.dart';

class QuotationPreviewPage extends StatefulWidget {
  final Quote quote;

  const QuotationPreviewPage({super.key, required this.quote});

  @override
  State<QuotationPreviewPage> createState() => _QuotationPreviewPageState();
}

class _QuotationPreviewPageState extends State<QuotationPreviewPage> {
  late Quote _quote;

  @override
  void initState() {
    super.initState();
    _quote = widget.quote;
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Quotation Preview"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Company Info
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    Row(
                      children: [
                        const Icon(Icons.business, color: Colors.blueAccent),
                        const SizedBox(width: 8),
                        const Text(
                          "Example Solutions",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                 
                const SizedBox(height: 4),
                 Text(
                      "Date: ${DateTime.now().toString().split(' ')[0]}",
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                const SizedBox(height: 4),
                const Text(
                  "123 Business Park, Mumbai\nEmail: example@gmail.com",
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),

          // Client Info
          Container(
            width: double.infinity,
            color: Colors.blue.shade50,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Quotation For:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('Name: ${_quote.client.name}', style: const TextStyle(fontSize: 15)),
                Text('Address: ${_quote.client.address}', style: const TextStyle(fontSize: 14)),
                Text("Reference: ${_quote.client.reference}",
                    style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),

          // Product Table
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    color: Colors.blue.shade100,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: const Row(
                      children: [
                        Expanded(flex: 3, child: Text("Item", style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(child: Text("Qty", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(child: Text("Price", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(child: Text("Total", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _quote.products.length,
                      itemBuilder: (context, index) {
                        final product = _quote.products[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          child: Row(
                            children: [
                              Expanded(flex: 3, child: Text(product.name)),
                              Expanded(child: Text("${product.quantity}", textAlign: TextAlign.center)),
                              Expanded(child: Text("₹${product.rate}", textAlign: TextAlign.center)),
                              Expanded(child: Text("₹${product.total.toStringAsFixed(2)}", textAlign: TextAlign.right)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  // Summary
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Subtotal:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("₹${_quote.subtotal.toStringAsFixed(2)}"),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Discount:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("- ₹${_quote.discount.toStringAsFixed(2)}"),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_quote.isTaxInclusive ? "Tax (Inclusive):" : "Tax (Exclusive):",
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text("₹${_quote.taxAmount.toStringAsFixed(2)}"),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Grand Total:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("₹${_quote.grandTotal.toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Thank you for your business!\nThis quotation is valid for 7 days.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
