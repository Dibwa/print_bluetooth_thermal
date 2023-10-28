// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class Bill_Info extends StatelessWidget {
  final String specification;
  final int price;
  final int quantity;
  const Bill_Info(
      {
      required this.specification,
      required this.price,
      required this.quantity});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      content: Container(
        height: 130,
        width: width,
        child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
          Row(
            children: [
              const Text("price: "),
              Expanded(
                child: Text(
                  "ZMW ${price.toString()}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 13,
          ),
          Row(
            children: [
              const Text("quantity: "),
              Text(quantity.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(
            height: 13,
          ),
          Row(
            children: [
              const Text("Specification: "),
              Expanded(
                child: Text(specification,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
