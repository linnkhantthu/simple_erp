import 'package:flutter/material.dart';
import 'package:simple_erp/users/register_page.dart';

Widget connectionLost(String data, Color color) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: progressBar(),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            Icons.info,
            color: color,
          ),
          Text(data)
        ]),
      ],
    ),
  );
}
