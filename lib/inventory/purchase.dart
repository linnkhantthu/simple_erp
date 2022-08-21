import 'package:flutter/material.dart';
import 'package:simple_erp/inventory/Objects/Product.dart';
import 'package:searchfield/searchfield.dart';

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
  List<Product> searchProducts = [
    const Product(
        id: 1,
        productName: "productName1",
        contains: 1,
        unit: "PCS",
        price: 2500.0,
        qty: 0),
    const Product(
        id: 2,
        productName: "productName2",
        contains: 2,
        unit: "KG",
        price: 3000.0,
        qty: 0),
    const Product(
        id: 3,
        productName: "productName3",
        contains: 3,
        unit: "G",
        price: 3500.0,
        qty: 0),
    const Product(
        id: 4,
        productName: "productName4",
        contains: 4,
        unit: "LB",
        price: 4500.0,
        qty: 0),
    const Product(
        id: 5,
        productName: "productName5",
        contains: 5,
        unit: "CM",
        price: 5500.0,
        qty: 0),
  ];
  late final TextEditingController _id;
  late final TextEditingController _productName;
  late final TextEditingController _contains;
  late final TextEditingController _price;

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
      DataRow(
        cells: <DataCell>[
          DataCell(SizedBox(
            width: 50,
            child: SearchField<Product>(
              suggestions: searchProducts
                  .map(
                    (e) => SearchFieldListItem(
                      e.id.toString(),
                      item: e,
                    ),
                  )
                  .toList(),
            ),
          )),
          DataCell(TextField()),
          DataCell(TextField()),
          DataCell(TextField()),
          DataCell(TextField()),
          DataCell(TextField()),
          DataCell(
            Icon(Icons.add),
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
