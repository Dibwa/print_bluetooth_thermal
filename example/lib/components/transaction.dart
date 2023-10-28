class Transaction {
  final String sender;

  final String receiver;

  final int amount;

  const Transaction({
    required this.sender,
    required this.receiver,
    required this.amount,
  });

  static Transaction fromJson(json) => Transaction(
      sender: json['sender'],
      receiver: json['receiver'],
      amount: json['amount']);
}
