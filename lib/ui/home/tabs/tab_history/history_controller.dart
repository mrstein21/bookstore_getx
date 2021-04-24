import 'package:book_store/mixins/user_session.dart';
import 'package:book_store/model/transaction.dart';
import 'package:book_store/repository/transaction_repository.dart';
import 'package:book_store/ui/login/login_controller.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController{
  TransactionRepository transactionRepository=Get.find<TransactionRepository>();
  ///variable ini bertipe observable supaya nanti bisa
  ///di listen di UI ketika nilai berubah
  ///nilai variable observable ini tidak akan hilang bahkan setelah berpindah pindah halaman
  ///pun nilai masih ada kecuali setelah aplikasi di destroy dan di buka kembali, variable observable
  ///akan di reset
  var list=new List<Transaction>().obs;
  var page=0.obs;
  var isLoading=true.obs;
  var isNoMoreLoad=false.obs;
  /// akses loginController supaya bisa mendapatkan userSession
  var loginController = Get.find<LoginController>();///...
  ///untuk binding ke variable observable caranya yaitu
  ///nama_variable.value=value_baru
  ///atau nama_variable(value_baru)
  void getTransaction() async{
    list.value=[];
    isLoading(true);
    isNoMoreLoad(false);
    page(1);
    transactionRepository.getTransaction(
      loginController.userSession.value["id"].toString()
    , 1).then((value){
      isLoading(false);
      //menambah list buku  dari json ke ke list observable,
      list.value=[...list.value,...value];
      if(value.length<10){
        isNoMoreLoad(true);
      }
    }).catchError((err,track){
      print("terjadi kesalahan pada list history "+err.toString());
      print("terjadi kesalahan pada list history "+track.toString());
      Get.snackbar("Pesan","Terjadi kesalahan pada server");
    });
  }


  void loadMore()async{
    print("kesini load more getX");
    page.value=page.value+1;
    transactionRepository.getTransaction(
        loginController.userSession.value["id"].toString()
        ,page.value).then((value){
      list.value=[...list.value,...value];
      //ketika value dari api list book me return empty list
      //maka dari itu data sudah terload semua
      //alias tidak ada load more lagi
      if(value.isEmpty){
        isNoMoreLoad(true);
      }
    }).catchError((err,track){
      print("terjadi kesalahan pada load more list history "+err.toString());
      print("terjadi kesalahan pada load more list history "+track.toString());
      Get.snackbar("Pesan","Terjadi kesalahan pada server");
    });
  }




}