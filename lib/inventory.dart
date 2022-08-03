import 'package:flutter/material.dart';
import 'package:simple_erp/inventory/Objects/Product.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  List<Product> products = [];
  final List columnNames = [
    "ID",
    "Product Name",
    "Contains",
    "Unit",
    "Price",
    "Qty"
  ];
  final List<Map<String, Object>> data = [
    {
      "id": 1,
      "productName": "Hat",
      "contains": 100,
      "unit": "PCS",
      "price": 2500.0,
      "qty": 200,
    },
    {
      "id": 2,
      "productName": "Shoes",
      "contains": 50,
      "unit": "PCS",
      "price": 25000.0,
      "qty": 150,
    },
    {
      "id": 1,
      "productName": "iPad",
      "contains": 1,
      "unit": "PCS",
      "price": 1100000.0,
      "qty": 5,
    },
    {
      "id": 1,
      "productName": "iPad",
      "contains": 1,
      "unit": "PCS",
      "price": 1100000.0,
      "qty": 5,
    },
    {
      "id": 1,
      "productName": "iPad",
      "contains": 1,
      "unit": "PCS",
      "price": 1100000.0,
      "qty": 5,
    },
    {
      "id": 1,
      "productName": "iPad",
      "contains": 1,
      "unit": "PCS",
      "price": 1100000.0,
      "qty": 5,
    },
    {
      "id": 1,
      "productName": "iPad",
      "contains": 1,
      "unit": "PCS",
      "price": 1100000.0,
      "qty": 5,
    },
    {
      "id": 1,
      "productName": "iPad",
      "contains": 1,
      "unit": "PCS",
      "price": 1100000.0,
      "qty": 5,
    },
    {
      "id": 1,
      "productName": "iPad",
      "contains": 1,
      "unit": "PCS",
      "price": 1100000.0,
      "qty": 5,
    },
    {
      "id": 1,
      "productName": "iPad",
      "contains": 1,
      "unit": "PCS",
      "price": 1100000.0,
      "qty": 5,
    },
    {
      "id": 1,
      "productName": "iPad",
      "contains": 1,
      "unit": "PCS",
      "price": 1100000.0,
      "qty": 5,
    },
    {
      "id": 1,
      "productName": "iPad",
      "contains": 1,
      "unit": "PCS",
      "price": 1100000.0,
      "qty": 5,
    },
    {
      "id": 1,
      "productName": "iPad",
      "contains": 1,
      "unit": "PCS",
      "price": 1100000.0,
      "qty": 5,
    },
    {
      "id": 1,
      "productName": "iPad",
      "contains": 1,
      "unit": "PCS",
      "price": 1100000.0,
      "qty": 5,
    },
    {
      "id": 1,
      "productName": "iPad",
      "contains": 1,
      "unit": "PCS",
      "price": 1100000.0,
      "qty": 5,
    },
  ];
  @override
  void initState() {
    for (var element in data) {
      products.add(Product.fromJson(element));
    }
    print(products);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Inventory"),
          DataTable(
              columns: List<DataColumn>.generate(columnNames.length,
                  (index) => DataColumn(label: Text(columnNames[index]))),
              rows: List<DataRow>.generate(
                  products.length,
                  (index) => DataRow(cells: <DataCell>[
                        DataCell(Text(products[index].id.toString())),
                        DataCell(Text(products[index].productName.toString())),
                        DataCell(Text(products[index].contains.toString())),
                        DataCell(Text(products[index].unit.toString())),
                        DataCell(Text(products[index].price.toString())),
                        DataCell(Text(products[index].qty.toString())),
                      ]))),
        ],
      ),
    );
  }
}
