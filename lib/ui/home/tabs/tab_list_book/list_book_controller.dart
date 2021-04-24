import 'package:book_store/model/book.dart';
import 'package:book_store/repository/book_repository.dart';
import 'package:get/get.dart';

class ListBookController extends GetxController{

  BookRepository bookRepository=Get.find<BookRepository>();
  ///variable ini bertipe observable supaya nanti bisa
  ///di listen di UI ketika nilai berubah
  ///nilai variable observable ini tidak akan hilang bahkan setelah berpindah pindah halaman
  ///pun nilai masih ada kecuali setelah aplikasi di destroy dan di buka kembali, variable observable
  ///akan di reset
  var list=new List<Book>().obs;
  var page=0.obs;
  var isLoading=true.obs;
  var isNoMoreLoad=false.obs;
  ///...

  ///untuk binding ke variable observable caranya yaitu
  ///nama_variable.value=value_baru
  ///atau nama_variable(value_baru)
  void getBook() async{
    list.value=[];
    isLoading(true);
    isNoMoreLoad(false);
    page(1);
    bookRepository.getBook(1).then((value){
      isLoading(false);
      //menambah list buku  dari json ke ke list observable,
      list.value=[...list.value,...value];
    }).catchError((err,track){
      print("terjadi kesalahan pada list book "+err.toString());
      print("terjadi kesalahan pada list book "+track.toString());
      Get.snackbar("Pesan","Terjadi kesalahan pada server");
    });
  }
 /// untuk proses parsing API book disarankan sambil melihat
  /// dokumentasi api supaya dapat dimengerti
  void loadMore()async{
    print("kesini load more getX");
    page.value=page.value+1;
    bookRepository.getBook(page.value).then((value){
      list.value=[...list.value,...value];
      //ketika value dari api list book me return empty list
      //maka dari itu data sudah terload semua
      //alias tidak ada load more lagi
      if(value.isEmpty){
        isNoMoreLoad(true);
      }
    }).catchError((err,track){
      print("terjadi kesalahan pada load more list book "+err.toString());
      print("terjadi kesalahan pada load more list book "+track.toString());
      Get.snackbar("Pesan","Terjadi kesalahan pada server");
    });
  }








}