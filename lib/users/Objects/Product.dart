class Product {
  final int id;
  final int product_id;
  final String productName;
  final int contains;
  final String unit;
  final double price;
  final double qty;
  final user_id;

  const Product(
      {required this.id,
      required this.product_id,
      required this.productName,
      required this.contains,
      required this.unit,
      required this.price,
      required this.qty,
      required this.user_id});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      product_id: json['product_id'],
      productName: json['productName'],
      contains: json['contains'],
      unit: json['unit'],
      price: json['price'],
      qty: json['qty'],
      user_id: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': product_id,
        'productName': productName,
        'contains': contains,
        'unit': unit,
        'price': price,
        'qty': qty,
        'user_id': user_id,
      };
}
