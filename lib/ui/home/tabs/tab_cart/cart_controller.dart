import 'dart:convert';

import 'package:book_store/mixins/user_session.dart';
import 'package:book_store/model/book.dart';
import 'package:book_store/repository/transaction_repository.dart';
import 'package:book_store/ui/home/home_controller.dart';
import 'package:book_store/ui/login/login_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CartController extends GetxController{
  ///bisa akses controller lain juga akses variable maupun fungsi
  HomeController homeController=Get.find<HomeController>();
  ProgressDialog progressDialog;
  TransactionRepository transactionRepository=Get.find<TransactionRepository>();
  LoginController loginController=Get.find<LoginController>();

  void initDialog(BuildContext context){
    progressDialog=ProgressDialog(context,isDismissible: false);
  }

  void showDialogTransaction(BuildContext context){
     showDialog(
       context:context,
       builder: (ctx){
         return AlertDialog(
           title: Text("Yakin ingin melakukan checkout ?"),
           actions: [
             FlatButton(
                 onPressed: (){
                   Navigator.of(context).pop();
                   goTransaction();
                 },
                 child: Text("Ya")),
             FlatButton(
                 onPressed: (){
                   Navigator.of(context).pop();
                 },
                 child: Text("Tidak"))
           ],
         );
       }
     );
  }

  void goTransaction()async{
    progressDialog.style(message: "Loading..");
    progressDialog.show();
    List<Map<String,dynamic>> request_BOOK= new List();
    for(int i=0;i<homeController.list_cart_book.length;i++){
      Map<String,dynamic> json2;
      Book book=homeController.list_cart_book[i];
      json2=book.toJson();
      request_BOOK.add(json2);

    }
    var body=json.encode(
        {
          "user_id":loginController.userSession["id"],
          "books":request_BOOK,
        }
    );
    transactionRepository.addTransaction(body).then((value){
      progressDialog.hide().whenComplete((){
        var content=json.decode(value);
        if(content["success"]=="1"){
          Get.snackbar("Pesan","Transaksi berhasil");
          homeController.deleteAllCart();
        }else{
          Get.snackbar("Pesan",content["message"]);
        }
      });
    }).catchError((err,track){
      progressDialog.hide().whenComplete((){
        print("terjadi kesalahan pada load more transaksi "+err.toString());
        print("terjadi kesalahan pada load more  transaksi "+track.toString());
        Get.snackbar("Pesan","Terjadi kesalahan pada server");
      });
    });
  }

}