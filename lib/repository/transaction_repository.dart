import 'package:book_store/mixins/server.dart';
import 'package:book_store/model/transaction.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TransactionRepository{
  String base_url=Server.url;

  Future<String> fetchTransactionDetail(String trans_id)async {
    var response = await http.get(base_url+"/transaction_detail/"+trans_id);
    if(response.statusCode==200){
      return response.body;
    }else{
      throw Exception();
    }
  }

  Future<String> addTransaction(body) async{
    var url=Server.url+"/transaction";
    var res = await http.post(Uri.encodeFull(url), body : body,headers: {'Content-type': 'application/json'});
    if (res.statusCode == 200) {
      return res.body;
    }else{
      throw Exception();
    }
  }

  Future<List<Transaction>> getTransaction(String id, int page) async {
    var response = await http.get(base_url+"/transaction_list/"+id+"?page="+page.toString());
    print(base_url+"/transaction_list/"+id+"?page="+page.toString());
    if(response.statusCode==200){
      return compute(transactionFromJson,response.body);
    }else{
      throw Exception();
    }
  }
}