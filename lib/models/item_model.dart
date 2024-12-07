class Item {
  final int id;
  final String itemName;
  final double price;
  final int qty;
  final double discount;
  final double total;

  Item({
    required this.id,
    required this.itemName,
    required this.price,
    required this.qty,
    required this.discount,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item': itemName,
      'price': price,
      'qty': qty,
      'discount': discount,
      'total': total,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      itemName: map['item'],
      price: map['price'],
      qty: map['qty'],
      discount: map['discount'],
      total: map['total'],
    );
  }
}
