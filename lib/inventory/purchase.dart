import 'package:flutter/material.dart';

class Purchase extends StatefulWidget {
  const Purchase({Key? key}) : super(key: key);

  @override
  State<Purchase> createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
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
                Text("Form"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
