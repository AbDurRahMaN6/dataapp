import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../viewmodels/item_viewmodel.dart';

class QuotationScreen extends StatefulWidget {
  const QuotationScreen({Key? key}) : super(key: key);

  @override
  State<QuotationScreen> createState() => _QuotationScreenState();
}

class _QuotationScreenState extends State<QuotationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime selectedDate = DateTime(2022, 12, 5);
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime(2022, 12, 5));
  String selectedOffice = "Auckland Offices";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _addItem(QuotationViewModel viewModel) {
    if (viewModel.itemController.text.isEmpty ||
        viewModel.reasonController.text.isEmpty ||
        viewModel.priceController.text.isEmpty ||
        viewModel.qtyController.text.isEmpty ||
        viewModel.discountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields must be filled'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    viewModel.addItem();
    viewModel.clearFields();
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item added successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuotationViewModel>(context);

    double totalAmount =
        viewModel.getItemsForCurrentPage().fold(0.0, (sum, item) {
      double price = item['price'];
      int quantity = item['qty'] ?? 1;
      double discount = item['discount'];
      double total = (price * quantity) * (1 - (discount / 100));
      return sum + total;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotation'),
        backgroundColor: const Color(0xFF4169E1),
        leading: IconButton(
          icon: const Icon(Icons.save),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.screen_share_sharp),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.check_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: selectedOffice,
                    items: [
                      "Auckland Offices",
                      "Auckland1 Offices",
                      "Auckland2 Offices",
                      "Auckland3 Offices"
                    ]
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: const TextStyle(
                                  color: Color(0xFF4169E1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedOffice = value;
                        });
                      }
                    },
                    style: const TextStyle(
                      color: Color(0xFF4169E1),
                    ),
                    dropdownColor: Colors.white,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF4169E1),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                          formattedDate =
                              DateFormat('yyyy-MM-dd').format(selectedDate);
                        });
                      }
                    },
                    child: Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4169E1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF4169E1),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: const Color(0xFF4169E1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF4169E1),
                  unselectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(child: Text('General')),
                    Tab(child: Text('Items')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF4169E1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Net Amount:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      ' ${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 500,
              child: TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          decoration: const InputDecoration(labelText: 'Item'),
                          controller: viewModel.itemController,
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          decoration:
                              const InputDecoration(labelText: 'Reason'),
                          controller: viewModel.reasonController,
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          decoration: const InputDecoration(labelText: 'Price'),
                          keyboardType: TextInputType.number,
                          controller: viewModel.priceController,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration:
                                    const InputDecoration(labelText: 'Qty'),
                                keyboardType: TextInputType.number,
                                controller: viewModel.qtyController,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                    labelText: 'Discount (%)'),
                                keyboardType: TextInputType.number,
                                controller: viewModel.discountController,
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () => _addItem(viewModel),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4169E1),
                              ),
                              child: const Text('ADD'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.all<Color>(
                                  Colors.grey[200]!),
                              columns: const [
                                DataColumn(label: Text('Item')),
                                DataColumn(label: Text('Price')),
                                DataColumn(label: Text('Quantity')),
                                DataColumn(label: Text('Discount')),
                                DataColumn(label: Text('Total')),
                              ],
                              rows: List.generate(
                                  viewModel.getItemsForCurrentPage().length,
                                  (index) {
                                var item =
                                    viewModel.getItemsForCurrentPage()[index];
                                double price = item['price'];
                                int quantity = item['qty'] ?? 1;
                                double discount = item['discount'];
                                double total =
                                    (price * quantity) * (1 - (discount / 100));
                                return DataRow(cells: [
                                  DataCell(Text(item['item'])),
                                  DataCell(Text(price.toString())),
                                  DataCell(Text(quantity.toString())),
                                  DataCell(Text(discount.toString())),
                                  DataCell(Text(total.toStringAsFixed(2))),
                                ]);
                              }),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: viewModel.previousPage,
                            ),
                            Text(
                                'Page ${viewModel.currentPage + 1} of ${viewModel.totalPages}'),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: viewModel.nextPage,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Center(child: Text('Items Tab Content')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
