import 'package:flutter/material.dart';
import '../../models/product_model.dart';

class AddProductPage extends StatefulWidget {
  final Product product;

  const AddProductPage({super.key, required this.product});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _rateController;
  late TextEditingController _qtyController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _rateController =
        TextEditingController(text: widget.product.rate.toString());
    _qtyController =
        TextEditingController(text: widget.product.quantity.toString());
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = Product(
        name: _nameController.text,
        rate: double.parse(_rateController.text),
        quantity: int.parse(_qtyController.text),
      );

      Navigator.pop(context, updatedProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add/Update Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form( // 👈 Add Form widget here
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  if (value.trim().isEmpty) {
                    return 'Product name cannot be just spaces';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _rateController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter rate';
                  }
                  if (double.tryParse(value) == null|| double.parse(value) <= 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Rate'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _qtyController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  if (int.tryParse(value) == null|| int.parse(value) <= 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
