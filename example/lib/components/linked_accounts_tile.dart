import 'package:flutter/material.dart';

class Linked_Account_Tile extends StatelessWidget {

  final String accountphoneNumber;

  final Function()? buttonFunction;

  const Linked_Account_Tile(
      {
  
      required this.accountphoneNumber,
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
           
           
                SizedBox(
                  height: 10,
                ),
                Text(
                  accountphoneNumber,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black.withOpacity(0.4)),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
           Container(margin: EdgeInsets.only(right: 8),child: Icon(Icons.sync,color: Colors.green)),
                SizedBox(
                  height: 10,
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
