import 'package:flutter/material.dart';
import 'package:simple_erp/inventory/Objects/Product.dart';
import 'package:simple_erp/inventory/addProduct.dart';
import 'package:simple_erp/inventory/utils.dart';
import 'package:simple_erp/users/register_page.dart';
import 'package:simple_erp/users/utils.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  late Object? currentUser;
  late Future<List<Object>> products;
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
    currentUser = getCurrentUser('current_user'); // Get current user
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchInventory(),
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return progressBar();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.warning,
                      color: Colors.red,
                    ),
                    Text("No internet connection to server"),
                  ],
                ),
              );
            } else {
              return Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 1000,
                  child: FittedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => const SizedBox(
                                      width: 200,
                                      height: 500,
                                      child: AlertDialog(
                                        actions: [
                                          AddProduct(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.green)),
                                child: const Text(
                                  "Add Product",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {});
                              },
                              child: const Icon(Icons.refresh),
                            )
                          ],
                        ),
                        DataTable(
                            columns: List<DataColumn>.generate(
                                columnNames.length,
                                (index) => DataColumn(
                                    label: Text(columnNames[index]))),
                            rows: List<DataRow>.generate(
                                (snapshot.data as List<Product>).length,
                                (index) => DataRow(cells: <DataCell>[
                                      DataCell(Text((snapshot.data
                                              as List<Product>)[index]
                                          .id
                                          .toString())),
                                      DataCell(Text((snapshot.data
                                              as List<Product>)[index]
                                          .productName
                                          .toString())),
                                      DataCell(Text((snapshot.data
                                              as List<Product>)[index]
                                          .contains
                                          .toString())),
                                      DataCell(Text((snapshot.data
                                              as List<Product>)[index]
                                          .unit
                                          .toString())),
                                      DataCell(Text((snapshot.data
                                              as List<Product>)[index]
                                          .price
                                          .toString())),
                                      DataCell(Text((snapshot.data
                                              as List<Product>)[index]
                                          .qty
                                          .toString())),
                                    ]))),
                      ],
                    ),
                  ),
                ),
              );
            }

          default:
            return progressBar();
        }
      },
    );
  }
}
