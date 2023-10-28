// ignore_for_file: camel_case_types, must_be_immutable, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:flutter/material.dart';


import 'button.dart';
import 'my_textfied.dart';

class Add_To_Cart extends StatelessWidget {
  var specification;
  final Function()? add_to_cart;
  Add_To_Cart(
      {super.key, required this.specification, required this.add_to_cart});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      content: Container(
        height: 130,
        width: width,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: InputField(
                  onchanged: (value) {},
                  keyboarType: TextInputType.text,
                  prefixIcon: const Icon(Icons.lock_clock),
                  inputs: specification,
                  textHint: 'Sizes wanted',
                  secure: false)),
          const SizedBox(
            height: 13,
          ),
          MyButton(
              lable: "Add",
              function: add_to_cart,
              isLoading: false,
              buttoncolor: Colors.black)
        ]),
      ),
    );
  }
}
