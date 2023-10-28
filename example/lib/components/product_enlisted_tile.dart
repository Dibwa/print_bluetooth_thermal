import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Products_Enlisted_Tile extends StatefulWidget {
  final String productName;
  final String productPrice;
  final String productQuantity;
  final String product_metric_quantity;

  final Function()? function_delete;
  final Function()? function_edit;
  const Products_Enlisted_Tile({
 
    required this.function_delete,
        required this.function_edit,
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
    required this.product_metric_quantity,
  });

  @override
  State<Products_Enlisted_Tile> createState() => _Products_Enlisted_TileState();
}

class _Products_Enlisted_TileState extends State<Products_Enlisted_Tile> {
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
                            Expanded(
                              child: Text(
                                widget.productName.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.65)),
                              ),
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
                          "ZMW ${widget.productPrice} X ${widget.product_metric_quantity} ${widget.productQuantity}",
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
              children: [  GestureDetector(
                  onTap: widget.function_edit,
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade500,
                        borderRadius: BorderRadius.circular(2)),
                    child:
                        const Icon(Icons.edit, size: 20, color: Colors.black),
                  ),
                ),       const SizedBox(
                    height: 6,
                  ),
                GestureDetector(
                  onTap: widget.function_delete,
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(2)),
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
