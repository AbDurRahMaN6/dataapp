import 'package:flutter/material.dart';

class QuotationViewModel with ChangeNotifier {
  final TextEditingController itemController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  List<Map<String, dynamic>> items = [];
  int currentPage = 1;
  int itemsPerPage = 5;

  void addItem() {
    final item = {
      'item': itemController.text,
      'price': double.tryParse(priceController.text) ?? 0.0,
      'qty': int.tryParse(qtyController.text) ?? 1,
      'discount': double.tryParse(discountController.text) ?? 0.0,
    };
    items.add(item);
    notifyListeners();
  }

  void clearFields() {
    itemController.clear();
    priceController.clear();
    qtyController.clear();
    discountController.clear();
    reasonController.clear();
  }

  List<Map<String, dynamic>> getItemsForCurrentPage() {
    final start = (currentPage - 1) * itemsPerPage;
    final end = start + itemsPerPage;
    return items.sublist(start, end > items.length ? items.length : end);
  }

  void nextPage() {
    if (currentPage * itemsPerPage < items.length) {
      currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (currentPage > 1) {
      currentPage--;
      notifyListeners();
    }
  }
}
