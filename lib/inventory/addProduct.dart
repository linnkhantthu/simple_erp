import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key, required this.units}) : super(key: key);
  final List units;

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  late final TextEditingController _id;
  late final TextEditingController _productName;
  late final TextEditingController _contains;
  late final List _unit;
  late final TextEditingController _price;
  late IO.Socket socket;
  late List units;

  var _idErrorText = null;
  var _productNameErrorText = null;
  var _containsErrorText = null;
  var _priceErrorText = null;

  @override
  void initState() {
    socket = IO.io('http://localhost:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _id = TextEditingController();
    _productName = TextEditingController();
    _contains = TextEditingController();
    _price = TextEditingController();
    setState(() {
      _unit = widget.units;
    });
    super.initState();
  }

  @override
  void dispose() {
    _id.dispose();
    _productName.dispose();
    _contains.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Add Product",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      enabled: false,
                      controller: _id,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: "ID",
                          errorText: _idErrorText),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: _productName,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: "Product Name",
                          errorText: _productNameErrorText),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: _contains,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: "Contains",
                          errorText: _containsErrorText),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: DropdownButton(
                    value: _unit[0],
                    items:
                        _unit.map<DropdownMenuItem<dynamic>>((dynamic value) {
                      return DropdownMenuItem<dynamic>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (dynamic value) {
                      setState(() {
                        _unit = value!;
                      });
                    },
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'(^\d*\.?\d*)'),
                        ),
                      ],
                      controller: _price,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: "Price",
                          errorText: _priceErrorText),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  child: const Text(
                    "Add",
                    style: TextStyle(color: Colors.black),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
