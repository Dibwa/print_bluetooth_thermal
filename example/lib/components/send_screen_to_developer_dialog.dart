// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class Customer_Support extends StatelessWidget {
  final Function()? send_message_to_support_team;
  final Function()? url_direct;
  const Customer_Support({
 
    required this.send_message_to_support_team,
    required this.url_direct,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      content: Container(
        height: 220,
        width: width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "SUPPORT TEAM",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                        "A screenshot will be taken of the current screen",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.black)),
                      fillColor: Colors.grey,
                      hintText: "Describe the nature of the problem")),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        url_direct!();
                      },
                      child: const Text("Watch Tutorial")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        send_message_to_support_team!();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Issue submitted to Support Team'),
                          ),
                        );
                      },
                      child: const Text("Submit issue"))
                ],
              ),
            ]),
      ),
    );
  }
}
