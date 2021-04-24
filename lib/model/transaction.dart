
import 'dart:convert';

List<Transaction> transactionFromJson(String response){
  final jsonData = json.decode(response);
  final data=jsonData["data"];
  return new List<Transaction>.from(data.map((x) => Transaction.fromJson(x)));
}

class Transaction{
  String trans_id;
  String date;
  String total;

  Transaction({
    this.trans_id,
    this.date,
    this.total
  });


  factory Transaction.fromJson(Map<String,dynamic> json)=>new Transaction(
    trans_id  :   json["trans_id"],
    date: json["date"],
    total: json["total"],
  );



}