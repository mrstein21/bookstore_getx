import 'dart:convert';

import 'package:book_store/mixins/user_session.dart';
import 'package:book_store/model/book.dart';
import 'package:book_store/model/transaction.dart';
import 'package:book_store/repository/transaction_repository.dart';
import 'package:get/get.dart';

class DetailHistoryController extends GetxController{
  TransactionRepository transactionRepository=Get.find<TransactionRepository>();
  ///variable ini bertipe observable supaya nanti bisa
  ///di listen di UI ketika nilai berubah
  ///nilai variable observable ini tidak akan hilang bahkan setelah berpindah pindah halaman
  ///pun nilai masih ada kecuali setelah aplikasi di destroy dan di buka kembali, variable observable
  ///akan di reset
   var date="".obs;
   var total="".obs;
   var transaction_id="".obs;
   var list_book=new List<Book>().obs;
   var isLoading=true.obs;
///...
  ///untuk binding ke variable observable caranya yaitu
  ///nama_variable.value=value_baru
  ///atau nama_variable(value_baru)
  void getDetail(String id_transaction) async{
     isLoading(true);
     transactionRepository.fetchTransactionDetail(id_transaction).then((response){
       var content=json.decode(response);
       date.value=content["info"]["date"];
       transaction_id.value=content["info"]["trans_id"];
       total.value=content["info"]["total"];
       list_book.value=bookFromJson(response);
       isLoading(false);
     }).catchError((err,track){
       print("terjadi kesalahan pada detail transaction "+err.toString());
       print("terjadi kesalahan pada detail transactiom "+track.toString());
       Get.snackbar("Pesan","Terjadi kesalahan pada server");
     });

  }

}