class Product {
  final int id;
  final product_id;
  final String productName;
  final int contains;
  final String unit;
  final double price;
  final int qty;

  const Product(
      {required this.id,
      required this.product_id,
      required this.productName,
      required this.contains,
      required this.unit,
      required this.price,
      required this.qty});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        productName: json['productName'],
        contains: json['contains'],
        unit: json['unit'],
        price: json['price'],
        qty: json['qty'],
        product_id: json['product_id']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': product_id,
        'productName': productName,
        'contains': contains,
        'unit': unit,
        'price': price,
        'qty': qty
      };
}
