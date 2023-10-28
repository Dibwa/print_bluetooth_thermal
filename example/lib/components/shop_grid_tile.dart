// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'my_button.dart';

class Shop_Grid_Tile extends StatefulWidget {
  final String image;

  final String price;
  final String sizesAvailable;

  final Function()? add_to_cart;

  const Shop_Grid_Tile({
  
    required this.add_to_cart,
    required this.image,
    required this.sizesAvailable,
    required this.price,
  });

  @override
  State<Shop_Grid_Tile> createState() => _Shop_Grid_TileState();
}

class _Shop_Grid_TileState extends State<Shop_Grid_Tile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              color: Color.fromARGB(255, 182, 176, 176),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(1, 1))
        ],
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            height: 160,
            width: 157,
            child: Image.network(
              widget.image,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 3),
                  child: Row(children: [
                    Text(
                      "ZMW ",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.65)),
                    ),
                    Text(
                      widget.price,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.65)),
                    )
                  ]),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 3),
                  child: Row(children: [
                    Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Text(
                          widget.sizesAvailable,
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.65),
                              fontSize: 12),
                        )),
                  ]),
                ),
                const SizedBox(
                  height: 10,
                ),
          
                GestureDetector(
                  onTap: widget.add_to_cart,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black,
                      ),
                      child: const Text(
                        "Add to cart",
                        style: TextStyle(color: Colors.white),
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
