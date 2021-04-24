import 'package:book_store/mixins/server.dart';
import 'package:book_store/model/book.dart';
import 'package:book_store/model/transaction.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BookRepository{
  String base_url=Server.url;
// silahkan liat di dokumentasi API  tentang parameter
  // dan response
  Future<List<Book>> getBook(int page) async {
    var response = await http.get(base_url+"/book?page="+page.toString());
    // print(response.body);
    if (response.statusCode == 200) {
      //print("hello");
      return compute(bookFromJson,response.body);
    } else {
      throw Exception();
    }
  }



  Future<List<Book>> searchBook(String keyword, int page) async {
    var response = await http.get(base_url+"/book/search/"+keyword+"?page="+page.toString());
    // print(response.body);
    if (response.statusCode == 200) {
      //print("hello");
      return compute(bookFromJson,response.body);
    } else {
      throw Exception();
    }
    // TODO: implement searchBook
  }


}