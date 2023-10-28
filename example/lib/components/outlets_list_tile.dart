import 'package:flutter/material.dart';

class OutletTile extends StatelessWidget {
  final String productName;
  final int productAmount;
  final String productUrl;

  final Function()? buttonFunction;

  final int productUnit;
  const OutletTile(
      {
      required this.productName,
      required this.productAmount,
      required this.productUnit,
      required this.productUrl,

      required this.buttonFunction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      margin: EdgeInsets.only(top: 10),
      color: Color(0xFFf2f2f2),
      child: Container(
        margin: EdgeInsets.only(left: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text('from:', style: TextStyle(color: Colors.black)),
                  Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        productName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.7)),
                      )),
                ]),
                SizedBox(
                  height: 12,
                ),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Image(
                    fit: BoxFit.cover,
                    image: AssetImage(productUrl),
                    width: 55,
                    height: 55,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "ZMW ${productAmount.toString()}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black.withOpacity(0.7)),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: Offset(4, 4))
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          topLeft: Radius.circular(25))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: buttonFunction,
                          child: const Text(
                            'PAY',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0022b0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 58,
                ),
                Container(
                  padding: EdgeInsets.only(right: 8),
                  child: Text('02 Feb 2024',
                      style: TextStyle(color: Colors.black45, fontSize: 10)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
