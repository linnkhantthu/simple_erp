import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  late final TextEditingController _id;
  late final TextEditingController _productName;
  var _idErrorText = null;
  var _productNameErrorText = null;
  String dropdownValue = 'One';

  @override
  void initState() {
    _id = TextEditingController();
    _productName = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        child: Column(
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
            SizedBox(
              width: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _id,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: "ID",
                            errorText: _idErrorText),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: 200,
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
            ),
            SizedBox(
              width: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _id,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: "Contains",
                            errorText: _idErrorText),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: 200,
                      child: DropdownButton(
                        value: dropdownValue,
                        items: <String>['One', 'Two', 'Free', 'Four']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
