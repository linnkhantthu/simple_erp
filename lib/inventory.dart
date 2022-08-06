import 'package:flutter/material.dart';
import 'package:simple_erp/inventory/Objects/Product.dart';
import 'package:simple_erp/inventory/addProduct.dart';
import 'package:simple_erp/inventory/utils.dart';
import 'package:simple_erp/users/register_page.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  late Future<List<Product>> products;
  late Future<Object> productsFromServer;
  List<Product> socketProducts = [];
  StreamSocket streamSocket = StreamSocket();
  final List columnNames = [
    "ID",
    "Product Name",
    "Contains",
    "Unit",
    "Price",
    "Qty"
  ];

  Future<void> connectAndListen() async {
    IO.Socket socket = IO.io('http://localhost:5000',
        OptionBuilder().setTransports(['websocket']).build());
    socket.connect();
    socket.onConnect((_) {
      print('Connected');
      socket.emit('msg', 'test');
    });

    //When an event recieved from server, data is added to the stream
    // socket.on('event', (data) => streamSocket.getResponse);
    socket.on('fromServer', (data) {
      print(data);
      setState(() {
        streamSocket.getResponse;
      });
      socket.onDisconnect((_) => print('disconnect'));
    });
  }

  @override
  void initState() {
    connectAndListen();
    productsFromServer = fetchInventory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamSocket.getResponse,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        print(snapshot.hasError);
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return progressBar();
          case ConnectionState.done:
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
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
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
          default:
            return progressBar();
        }
      },
    );
  }
}
