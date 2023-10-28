import 'package:flutter/material.dart';

class CheckoutTile extends StatefulWidget {
  final String firstName;
  final String phoneNumber;

  const CheckoutTile({

    required this.firstName,
    required this.phoneNumber,
  });

  @override
  State<CheckoutTile> createState() => _CheckoutTileState();
}

class _CheckoutTileState extends State<CheckoutTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 15.0, bottom: 15),
        margin: const EdgeInsets.only(top: 2.0, bottom: 2),
        decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5.0),
              child: Row(
                children: [Text(widget.firstName)],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 5.0, bottom: 5, top: 5),
              child: Row(
                children: [
                  Text(
                    "ZMW ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
