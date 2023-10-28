import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductTile extends StatefulWidget {
  final String productName;
  final String productPrice;
  final String productQuantity;
  final int productsubTotal;

  final Function()? function;

  const ProductTile({
    super.key,
    required this.function,
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
    required this.productsubTotal,
  });

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15),
      margin: const EdgeInsets.only(top: 10),
      color: Colors.grey.shade200,
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Row(children: [
                    Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Row(
                          children: [
                            Text(
                              widget.productName,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.65)),
                            ),
                          ],
                        ))
                  ]),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(children: [
                    Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Text(
                          "ZMW ${widget.productPrice} X ${widget.productQuantity}",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.65),
                              fontSize: 12),
                        )),
                  ]),
                ],
              ),
            ),
            Expanded(
                child: Column(
              children: [
                GestureDetector(
                  onTap: widget.function,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5)),
                    child:
                        const Icon(Icons.delete, size: 20, color: Colors.white),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
