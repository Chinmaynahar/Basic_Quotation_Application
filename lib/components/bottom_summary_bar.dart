import 'package:flutter/material.dart';
import 'package:quote_builder/models/quote_model.dart';
import 'package:quote_builder/pages/quotation_preview_page.dart';
import 'package:quote_builder/services/hive_service.dart';

class BottomSummaryBar extends StatefulWidget {
  final double subtotal;
  final double discount;
  final double tax;
  final bool isTaxInclusive;
  final Quote quote;
  final Function(double, double, bool) onValuesChanged;

  const BottomSummaryBar({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.isTaxInclusive,
    required this.onValuesChanged,
    required this.quote,
  });

  @override
  State<BottomSummaryBar> createState() => _BottomSummaryBarState();
}

class _BottomSummaryBarState extends State<BottomSummaryBar> {
  bool _expanded = false;
  late double _discount;
  late double _tax;
  late bool _isTaxInclusive;

  late TextEditingController _discountController;
  late TextEditingController _taxController;

  final FocusNode _discountFocus = FocusNode();

@override
void initState() {
  super.initState();
  _discount = widget.discount;
  _tax = widget.tax;
  _isTaxInclusive = widget.isTaxInclusive;

  _discountController =
      TextEditingController(text: _discount.toStringAsFixed(2));
  _taxController = TextEditingController(text: _tax.toStringAsFixed(2));

  _discountFocus.addListener(() {
    // Validate only when user leaves the discount field
    if (!_discountFocus.hasFocus) {
      if (_discount > widget.subtotal) {
        setState(() {
          _discount = widget.subtotal;
          _discountController.text = _discount.toStringAsFixed(2);
        });
      }
      _updateValues();
    }
  });
}

  @override
  void dispose() {
    _discountController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  double get _grandTotal {
    double total = widget.subtotal - _discount;
    if (_isTaxInclusive) {
      total += (widget.subtotal * _tax / 100);
    }
    return total.clamp(0, double.infinity); // prevent negatives
  }

  void _updateValues() {
    widget.onValuesChanged(_discount, _tax, _isTaxInclusive);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      height: _expanded ? 400 : 180,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Subtotal + Expand Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal: ₹${widget.subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () => setState(() => _expanded = !_expanded),
                ),
              ],
            ),

            if (_expanded) ...[
              const Divider(),
              const SizedBox(height: 8),

              // Discount field
              TextField(
  focusNode: _discountFocus,
  controller: _discountController,
  decoration: InputDecoration(
    labelText: 'Discount (₹)',
    border: const OutlineInputBorder(),
    errorText: _discount > widget.subtotal
        ? 'Cannot exceed subtotal'
        : null,
  ),
  keyboardType: TextInputType.number,
  onChanged: (v) {
    setState(() {
      _discount = double.tryParse(v) ?? 0;
    });
  },
),
              const SizedBox(height: 10),

              // Tax field
              TextField(
                controller: _taxController,
                decoration: const InputDecoration(
                  labelText: 'Tax (%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) {
                  setState(() {
                    _tax = double.tryParse(v) ?? 0;
                  });
                  _updateValues();
                },
              ),
              const SizedBox(height: 10),

              // Tax switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tax Inclusive'),
                  Switch(
                    value: _isTaxInclusive,
                    onChanged: (v) {
                      setState(() {
                        _isTaxInclusive = v;
                      });
                      _updateValues();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(
                      'Grand Total: ₹${_grandTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                    ),
               ],
             ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.preview),
                      label: const Text('Preview'),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.black),
                        ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                          QuotationPreviewPage(
                            quote: Quote(
                              client: widget.quote.client,
                              products: widget.quote.products,
                              discount: _discount,
                              tax: _tax,
                              isTaxInclusive: _isTaxInclusive,
                          ),
                          )
                        ));
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.green),
                      ),
                      onPressed: () {
                        HiveService.addQuote( 
                          Quote(
                            client: widget.quote.client,
                            products: widget.quote.products,
                            discount: _discount,
                            tax: _tax,
                            isTaxInclusive: _isTaxInclusive,
                          ),
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
