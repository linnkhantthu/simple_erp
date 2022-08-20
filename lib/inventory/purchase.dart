import 'package:flutter/material.dart';
import 'package:simple_erp/inventory/Objects/Product.dart';

class Purchase extends StatefulWidget {
  const Purchase({Key? key}) : super(key: key);

  @override
  State<Purchase> createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  final List columnNames = [
    "ID",
    "Product Name",
    "Contains",
    "Unit",
    "Price",
    "Qty",
    ""
  ];
  final TextStyle dataTableStyle = const TextStyle(fontSize: 30);
  List<Product> products = [
    const Product(
        id: 1,
        productName: "TestData",
        contains: 10,
        unit: "PCS",
        price: 2500.0,
        qty: 0)
  ];
  late List<DataRow> dataRows;

  @override
  void initState() {
    dataRows = List<DataRow>.generate(
      products.length,
      (index) => DataRow(
        cells: <DataCell>[
          DataCell(Text(products[index].id.toString(), style: dataTableStyle)),
          DataCell(Text(products[index].productName.toString(),
              style: dataTableStyle)),
          DataCell(
              Text(products[index].contains.toString(), style: dataTableStyle)),
          DataCell(
              Text(products[index].unit.toString(), style: dataTableStyle)),
          DataCell(
              Text(products[index].price.toString(), style: dataTableStyle)),
          DataCell(Text(products[index].qty.toString(), style: dataTableStyle)),
          const DataCell(
            Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
    dataRows.add(
      const DataRow(
        cells: <DataCell>[
          DataCell(TextField()),
          DataCell(TextField()),
          DataCell(TextField()),
          DataCell(TextField()),
          DataCell(TextField()),
          DataCell(TextField()),
          DataCell(
            Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        child: SingleChildScrollView(
          child: FittedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text("Suppliers"),
                    ),
                  ],
                ),
                DataTable(
                  columns: List<DataColumn>.generate(
                      columnNames.length,
                      (index) => DataColumn(
                              label: Text(
                            columnNames[index],
                            style: dataTableStyle,
                          ))),
                  rows: dataRows,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
