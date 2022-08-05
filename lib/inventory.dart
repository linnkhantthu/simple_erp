import 'package:flutter/material.dart';
import 'package:simple_erp/inventory/Objects/Product.dart';
import 'package:simple_erp/inventory/addProduct.dart';
import 'package:simple_erp/inventory/utils.dart';
import 'package:simple_erp/users/register_page.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  late Future<List<Product>> products;
  late Future<Object> productsFromServer;
  final List columnNames = [
    "ID",
    "Product Name",
    "Contains",
    "Unit",
    "Price",
    "Qty"
  ];

  @override
  void initState() {
    productsFromServer = fetchInventory();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: productsFromServer,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => const SizedBox(
                      width: 200,
                      height: 500,
                      child: AlertDialog(
                        actions: [
                          FittedBox(
                            child: AddProduct(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  child: const Text(
                    "Add Product",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              DataTable(
                  columns: List<DataColumn>.generate(columnNames.length,
                      (index) => DataColumn(label: Text(columnNames[index]))),
                  rows: List<DataRow>.generate(
                      (snapshot.data as List<Product>).length,
                      (index) => DataRow(cells: <DataCell>[
                            DataCell(Text(
                                (snapshot.data as List<Product>)[index]
                                    .id
                                    .toString())),
                            DataCell(Text(
                                (snapshot.data as List<Product>)[index]
                                    .productName
                                    .toString())),
                            DataCell(Text(
                                (snapshot.data as List<Product>)[index]
                                    .contains
                                    .toString())),
                            DataCell(Text(
                                (snapshot.data as List<Product>)[index]
                                    .unit
                                    .toString())),
                            DataCell(Text(
                                (snapshot.data as List<Product>)[index]
                                    .price
                                    .toString())),
                            DataCell(Text(
                                (snapshot.data as List<Product>)[index]
                                    .qty
                                    .toString())),
                          ]))),
            ],
          );
        } else {
          return progressBar();
        }
      },
    );
  }
}
