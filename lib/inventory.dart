import 'package:flutter/material.dart';
import 'package:simple_erp/inventory/Objects/Product.dart';
import 'package:flutter/services.dart';
import 'package:simple_erp/inventory/utils.dart';
import 'package:simple_erp/users/Objects/User.dart';
import 'package:simple_erp/users/register_page.dart';
import 'package:simple_erp/users/utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  late final TextEditingController _id;
  late final TextEditingController _productName;
  late final TextEditingController _contains;
  late String _unit;
  late List<String> _units;
  late final TextEditingController _price;
  List<Product> products = [];
  var product;

  var _idErrorText = null;
  var _productNameErrorText = null;
  var _containsErrorText = null;
  var _priceErrorText = null;

  IO.Socket socket = IO.io('http://localhost:5000', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });
  Object? currentUser = getCurrentUser('current_user'); // Get current user
  StreamSocket streamSocket = StreamSocket();
  final List columnNames = [
    "ID",
    "Product Name",
    "Contains",
    "Unit",
    "Price",
    "Qty"
  ];

  void addProduct() {
    socket.emit('addProduct', {
      "mail": (currentUser as User).mail,
      "id": _id.text,
      "productName": _productName.text,
      "contains": _contains.text,
      "unit": _unit,
      "price": _price.text
    });
    print("Products in Products List: $products");
    socket.on('addProduct', (data) {
      print("Data from 'addProduct'");
      product = data['data'];
    });
    Future.delayed(const Duration(seconds: 1), (() {
      products.add(Product.fromJson(product));
      streamSocket.addResponse(products);
    }));
  }

  @override
  void initState() {
    if (!socket.connected) {
      socket.connect();
    }
    socket.onConnect((_) {
      print("Connected");
      socket.emit('getProducts', currentUser);
    });

    //When an event recieved from server, data is added to the stream
    socket.onDisconnect((_) {
      print('Disconnected');
    });
    socket.on('getProducts', (data) {
      print("Data from 'getProducts'");
      _units = List<String>.from(data['units']);
      _unit = _units[0];
      // List<Product> products = [];
      for (var element in data['data']) {
        products.add(Product.fromJson(element));
      }
    });
    Future.delayed(const Duration(seconds: 1), (() {
      streamSocket.addResponse(products);
    }));
    _id = TextEditingController();
    _productName = TextEditingController();
    _contains = TextEditingController();
    _price = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    socket.dispose();
    _id.dispose();
    _productName.dispose();
    _contains.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamSocket.getResponse(),
      builder: (BuildContext context, AsyncSnapshot<List<Object>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return progressBar();
          case ConnectionState.active:
            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 1000,
                child: SingleChildScrollView(
                  child: FittedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => SizedBox(
                                  width: 200,
                                  height: 500,
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,
                                        void Function(void Function())
                                            setState) {
                                      return AlertDialog(
                                        actions: [
                                          FittedBox(
                                            child: Center(
                                              child: SizedBox(
                                                width: 400,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Text(
                                                        "Add Product",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Flexible(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: TextField(
                                                              // enabled: false,
                                                              controller: _id,
                                                              decoration: InputDecoration(
                                                                  border:
                                                                      const OutlineInputBorder(),
                                                                  hintText:
                                                                      "ID",
                                                                  errorText:
                                                                      _idErrorText),
                                                            ),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: TextField(
                                                              controller:
                                                                  _productName,
                                                              decoration: InputDecoration(
                                                                  border:
                                                                      const OutlineInputBorder(),
                                                                  hintText:
                                                                      "Product Name",
                                                                  errorText:
                                                                      _productNameErrorText),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Flexible(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: TextField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              inputFormatters: [
                                                                FilteringTextInputFormatter
                                                                    .digitsOnly
                                                              ],
                                                              controller:
                                                                  _contains,
                                                              decoration: InputDecoration(
                                                                  border:
                                                                      const OutlineInputBorder(),
                                                                  hintText:
                                                                      "Contains",
                                                                  errorText:
                                                                      _containsErrorText),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          child: DropdownButton(
                                                            value: _unit,
                                                            onChanged: (String?
                                                                newValue) {
                                                              setState(() {
                                                                _unit =
                                                                    newValue!;
                                                              });
                                                            },
                                                            items: _units.map<
                                                                DropdownMenuItem<
                                                                    String>>((String
                                                                value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child:
                                                                    Text(value),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: TextField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              inputFormatters: [
                                                                FilteringTextInputFormatter
                                                                    .allow(
                                                                  RegExp(
                                                                      r'(^\d*\.?\d*)'),
                                                                ),
                                                              ],
                                                              controller:
                                                                  _price,
                                                              decoration: InputDecoration(
                                                                  border:
                                                                      const OutlineInputBorder(),
                                                                  hintText:
                                                                      "Price",
                                                                  errorText:
                                                                      _priceErrorText),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: TextButton(
                                                          onPressed: () {
                                                            print("Pressed");
                                                            addProduct();
                                                          },
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .green)),
                                                          child: const Text(
                                                            "Add",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green)),
                            child: const Text(
                              "Add Product",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
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
              ),
            );
          default:
            return progressBar();
        }
      },
    );
  }
}
