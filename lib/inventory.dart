import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:simple_erp/error_codes.dart';
import 'package:simple_erp/errors/connection_lost.dart';
import 'package:simple_erp/inventory/Objects/Product.dart';
import 'package:flutter/services.dart';
import 'package:simple_erp/inventory/utils.dart';
import 'package:simple_erp/users/Objects/ErrorMessage.dart';
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
  var hostname = dotenv.env['HOST_NAME'];
  bool addingProduct = false;
  final EdgeInsets padding = const EdgeInsets.all(8);
  final TextStyle dataTableStyle = const TextStyle(fontSize: 30);
  late final TextEditingController _id;
  late final TextEditingController _productName;
  late final TextEditingController _contains;
  late String _unit;
  late List<String> _units;
  late final TextEditingController _price;
  List<Product> products = [];
  late Map<String, dynamic> product;
  late String? errorMessage;
  String? errorCode;
  String status = "Disconnected";
  bool isDisposed = false;

  late String? _idErrorText;
  late String? _productNameErrorText;
  late String? _containsErrorText;
  late String? _priceErrorText;

  late IO.Socket socket;
  Object? currentUser = getCurrentUser('current_user'); // Get current user
  StreamSocket streamSocket = StreamSocket();
  final List columnNames = [
    "ID",
    "Product Name",
    "Contains",
    "Unit",
    "Price",
    "Qty",
    ""
  ];

  @override
  void initState() {
    // Initialize socket
    socket = IO.io('http://$hostname', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    isDisposed = false;

    // Check if the socket is connected, if not, connect
    if (!socket.connected) {
      socket.connect();
    }

    // If the socket got connected, set the status and send User Object to the server
    socket.onConnect((_) {
      setState(() {
        status = "Connected";
      });
      socket.emit('getProducts', currentUser);
    });

    //The server will emit product list if the user is authenticated
    socket.on('getProducts', (data) {
      // Init Unit
      _units = List<String>.from(data['units']);
      _unit = _units[0];

      // Clearing the list that is stored product list. (In case the server restarts)
      products.clear();

      // Add data to the StreamBuilder
      for (var element in data['data']) {
        products.add(Product.fromJson(element));
      }
      streamSocket.addResponse(products);
    });

    errorCode = null;
    // Initializing controllers
    _id = TextEditingController();
    _productName = TextEditingController();
    _contains = TextEditingController();
    _price = TextEditingController();

    _idErrorText = null;
    _productNameErrorText = null;
    _containsErrorText = null;
    _priceErrorText = null;

    super.initState();

    // If the socket got disconnected (Set status)
    socket.onDisconnect((_) {
      if (!isDisposed) {
        setState(() {
          status = "Disconnected";
        });
      }
    });
  }

  @override
  void dispose() {
    isDisposed = true;
    socket.dispose();

    _id.dispose();
    _productName.dispose();
    _contains.dispose();
    _price.dispose();

    streamSocket.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamSocket.getResponse(),
      builder: (BuildContext context, AsyncSnapshot<List<Object>> snapshot) {
        switch (socket.connected) {
          case false:
            return connectionLost("Initializing connection...", Colors.cyan);
          case true:
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return connectionLost("Fetching data...", Colors.cyan);

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
                            Row(
                              children: [
                                Padding(
                                  padding: padding,
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
                                              if (addingProduct) {
                                                return progressBar();
                                              } else {
                                                return AlertDialog(
                                                  actions: [
                                                    FittedBox(
                                                      child: Center(
                                                        child: SizedBox(
                                                          width: 400,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    padding,
                                                                child:
                                                                    const Text(
                                                                  "Add Product",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Flexible(
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          padding,
                                                                      child:
                                                                          TextField(
                                                                        // enabled: false,
                                                                        controller:
                                                                            _id,
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter
                                                                              .digitsOnly
                                                                        ],
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
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          padding,
                                                                      child:
                                                                          TextField(
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
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          padding,
                                                                      child:
                                                                          TextField(
                                                                        keyboardType:
                                                                            TextInputType.number,
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
                                                                        padding,
                                                                    child:
                                                                        DropdownButton(
                                                                      value:
                                                                          _unit,
                                                                      onChanged:
                                                                          (String?
                                                                              newValue) {
                                                                        setState(
                                                                            () {
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
                                                                          value:
                                                                              value,
                                                                          child:
                                                                              Text(value),
                                                                        );
                                                                      }).toList(),
                                                                    ),
                                                                  ),
                                                                  Flexible(
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          padding,
                                                                      child:
                                                                          TextField(
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter
                                                                              .allow(
                                                                            RegExp(r'(^\d*\.?\d*)'),
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
                                                                    padding,
                                                                child:
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            _idErrorText = (_id.text != "")
                                                                                ? null
                                                                                : "This field can't be empty";
                                                                            _productNameErrorText = (_productName.text != "")
                                                                                ? null
                                                                                : "This field can't be empty";
                                                                            _containsErrorText = (_contains.text != "")
                                                                                ? null
                                                                                : "This field can't be empty";
                                                                            _priceErrorText = (_price.text != "")
                                                                                ? null
                                                                                : "This field can't be empty";
                                                                          });
                                                                          if (_idErrorText != null ||
                                                                              _productNameErrorText != null ||
                                                                              _containsErrorText != null ||
                                                                              _priceErrorText != null) {
                                                                          } else {
                                                                            if (socket.connected) {
                                                                              addProduct(context, setState);
                                                                            } else {
                                                                              Navigator.pop(context);
                                                                            }
                                                                          }
                                                                        },
                                                                        style: ButtonStyle(
                                                                            backgroundColor: MaterialStateProperty.all(Colors
                                                                                .green)),
                                                                        child:
                                                                            const Text(
                                                                          "Add",
                                                                          style:
                                                                              TextStyle(color: Colors.black),
                                                                        )),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.green)),
                                    child: const Text(
                                      "Add Product",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 30),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: padding,
                                  child: Text(
                                    "Status:  $status",
                                    style: const TextStyle(
                                      fontSize: 30,
                                    ),
                                  ),
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
                                rows: List<DataRow>.generate(
                                    (snapshot.data as List<Product>).length,
                                    (index) => DataRow(cells: <DataCell>[
                                          DataCell(Text(
                                              (snapshot.data
                                                      as List<Product>)[index]
                                                  .id
                                                  .toString(),
                                              style: dataTableStyle)),
                                          DataCell(Text(
                                              (snapshot.data
                                                      as List<Product>)[index]
                                                  .productName
                                                  .toString(),
                                              style: dataTableStyle)),
                                          DataCell(Text(
                                              (snapshot.data
                                                      as List<Product>)[index]
                                                  .contains
                                                  .toString(),
                                              style: dataTableStyle)),
                                          DataCell(Text(
                                              (snapshot.data
                                                      as List<Product>)[index]
                                                  .unit
                                                  .toString(),
                                              style: dataTableStyle)),
                                          DataCell(Text(
                                              (snapshot.data
                                                      as List<Product>)[index]
                                                  .price
                                                  .toString(),
                                              style: dataTableStyle)),
                                          DataCell(Text(
                                              (snapshot.data
                                                      as List<Product>)[index]
                                                  .qty
                                                  .toString(),
                                              style: dataTableStyle)),
                                          DataCell(
                                            const Icon(Icons.delete_outline),
                                            onTap: () => showDialog(
                                                context: context,
                                                builder:
                                                    (context) => AlertDialog(
                                                          title: Text(
                                                              "Delete product ID: ${(snapshot.data as List<Product>)[index].id}"),
                                                          content: const Text(
                                                              "Are you sure ?"),
                                                          actions: <Widget>[
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    "Cancel")),
                                                            TextButton(
                                                                onPressed: () {
                                                                  deleteProduct(
                                                                          (snapshot.data as List<Product>)[index]
                                                                              .id)
                                                                      .then(
                                                                          (value) {
                                                                    if (value
                                                                        is Product) {
                                                                      products.removeWhere((element) =>
                                                                          element
                                                                              .id ==
                                                                          value
                                                                              .id);
                                                                      streamSocket
                                                                          .addResponse(
                                                                              products);
                                                                    } else {
                                                                      print((value
                                                                              as ErrorText)
                                                                          .message);
                                                                    }
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ButtonStyle(
                                                                    foregroundColor:
                                                                        MaterialStateProperty.all(Colors
                                                                            .black),
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all(Colors
                                                                            .red)),
                                                                child:
                                                                    const Text(
                                                                        "Sure"))
                                                          ],
                                                        )),
                                          )
                                        ]))),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              default:
                return connectionLost("Fetching data...", Colors.cyan);
            }
          default:
            return connectionLost("Initializing connection...", Colors.cyan);
        }
      },
    );
  }

  Future<void> addProduct(
      BuildContext context, void Function(void Function()) setState) async {
    addingProduct = true;
    var dataToSend = {
      "mail": (currentUser as User).mail,
      "id": _id.text,
      "productName": _productName.text,
      "contains": _contains.text,
      "unit": _unit,
      "price": _price.text
    };

    socket.emit('addProduct', dataToSend);
    socket.on('addProduct', (data) {
      errorCode = data['errorCode'];
      if (errorCode == ErrorCodes.noError) {
        product = data['data'];
      } else {
        errorMessage = data['data'];
      }
    });

    await Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 0), () {});

      switch (errorCode) {
        case ErrorCodes.noError:
          errorCode = null;
          products.add(Product.fromJson(product));
          streamSocket.addResponse(products);
          _id.clear();
          _productName.clear();
          _contains.clear();
          _price.clear();
          _idErrorText = null;
          _productNameErrorText = null;
          _containsErrorText = null;
          _priceErrorText = null;

          Navigator.pop(context);
          return false;

        case ErrorCodes.sqlError:
          errorCode = null;
          setState(() {
            _idErrorText = errorMessage;
          });
          setState(() => addingProduct = true);
          return false;
        case ErrorCodes.productIdUniqueError:
          errorCode = null;
          setState(() {
            _idErrorText = errorMessage;
          });
          setState(() => addingProduct = true);
          return false;
        default:
          return socket.connected ? true : false;
      }
    });
    setState(() => addingProduct = false);
  }
}
