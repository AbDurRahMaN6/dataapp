import 'package:flutter/material.dart';

class QuotationViewModel extends ChangeNotifier {
  final TextEditingController itemController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  final List<Map<String, dynamic>> _items = [];

  int _currentPage = 0;
  final int _itemsPerPage = 2;

  int get currentPage => _currentPage;

  int get totalPages {
    if (_items.isEmpty) return 0;
    return (_items.length / _itemsPerPage).ceil();
  }

  List<Map<String, dynamic>> getItemsForCurrentPage() {
    int start = _currentPage * _itemsPerPage;
    int end = start + _itemsPerPage;
    if (end > _items.length) end = _items.length;
    return _items.sublist(start, end);
  }

  void addItem() {
    _items.add({
      'item': itemController.text,
      'reason': reasonController.text,
      'price': double.tryParse(priceController.text) ?? 0.0,
      'qty': int.tryParse(qtyController.text) ?? 1,
      'discount': double.tryParse(discountController.text) ?? 0.0,
    });
    notifyListeners();
  }

  void clearFields() {
    itemController.clear();
    reasonController.clear();
    priceController.clear();
    qtyController.clear();
    discountController.clear();
  }

  void nextPage() {
    if (_currentPage < totalPages - 1) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }
}
