import 'package:flutter/material.dart';

class Loan_Tile extends StatelessWidget {
  final String loanAmount;
  final int pay_date_days_remaining;

  final Function()? buttonFunction;

  const Loan_Tile(
      {super.key,
      required this.loanAmount,
      required this.pay_date_days_remaining,
      required this.buttonFunction, required loanStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      margin: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("ZMW $loanAmount",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("Pay Date: $pay_date_days_remaining days remaining",
                  style: const TextStyle(fontSize: 10)),
            ]),
          ),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              GestureDetector(
                onTap: buttonFunction,
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0022b0),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(255, 182, 170, 170),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(1, 1))
                      ],
                    ),
                    child: const Text(
                      "Pay",
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ]),
          )
        ],
      ),
    );
  }
}
