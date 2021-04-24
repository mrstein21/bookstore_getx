import 'package:book_store/model/book.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class HomeController extends GetxController{
  ///variable ini bertipe observable supaya nanti bisa
  ///di listen di UI ketika nilai berubah
  ///nilai variable observable ini tidak akan hilang bahkan setelah berpindah pindah halaman
  ///pun nilai masih ada kecuali setelah aplikasi di destroy dan di buka kembali ,variable observable
  ///akan di reset
  var currentIndex=0.obs;
  ///karena variable tipe Box<dynamic> tidak bisa di observable kan
  ///kita pakai variable List Book
  ///mungkin kalian bisa cari tahu supaya variable Box<dynamic> bisa di observable
  var list_cart_book=new List<Book>().obs;
  /// variable list_book_cart ini digunakan untuk dipakai di berbagai widget
  /// untuk mengetahui buku mana saja yang sudah masuk ke cart
  /// serta jumlah buku yang ada di cart
  Box<dynamic>box_cart;

  ///open hive untuk cart dan masukan nilai box cart ke list_cart_book
  void initCartBox()async{
    list_cart_book.clear();
    box_cart=await Hive.openBox("cart");
    for(int i=0;i<box_cart.length;i++){
      Book book=box_cart.getAt(i);
      list_cart_book.add(book);
    }
  }

  ///fungsi untuk menambahkan buku ke cart
  ///jika increase--true maka qty akan bertambah jika false
  ///qty akan berkurang
  ///untuk simpan list ke hive perlu ada tahapannya tidak seperti,mensave UserSession
  ///karena kita menyimpan ke hive menggunakan class
  ///untuk lebih jelasnya silahkan liat ke model book.dart
  void updateCart(Book book,bool increase){
    //boolean untuk menandakan bahwa buku itu sudah ada di
    //cart atau belum...
    bool exist=false;
    for (int i = 0; i < box_cart.length; i++) {
      Book box = box_cart.getAt(i);
      if (book.id == box.id) {
        if (increase == true) {
          box.qty = box.qty + 1;
          box_cart.putAt(i, box);
        } else {
          if (box.qty - 1 == 0) {
            ///buku di cart akan di hapus ketika qty menjadi 0
            box.qty = box.qty - 1;
            box_cart.deleteAt(i);
          } else {
            box.qty = box.qty - 1;
            box_cart.putAt(i, box);
          }
        }
        exist = true;
        break;
      }
    }
    ///jika belum ada di cart maka masukkan entry baru ke hive
    if (exist == false && increase == true) {
      print("add cart executed");
      box_cart.add(book);
    }
    /// isi nilai kembali List Cart yang ada di hive ke
    /// variable list_cart_book
    initCartBox();
  }

  // menghapus buku yang ada di Hive berdasarkan index
  void deleteCart(Book book){
    for(int i=0;i<box_cart.length;i++){
      Book box=box_cart.getAt(i);
      if(book.id==box.id){
        box_cart.deleteAt(i);
      }
    }
    /// isi nilai kembali List Cart yang ada di hive ke
    /// variable list_cart_book
    initCartBox();
  }

  ///untuk binding ke variable observable caranya yaitu
  ///nama_variable.value=value_baru
  ///atau nama_variable(value_baru)
  void changeIndex(int newIndex){
    currentIndex(newIndex);
  }

  ///delete list dan book
  void deleteAllCart(){
    box_cart.clear();
    list_cart_book.clear();
    //update list_book_cart
  }

  //fungsi ini akan dieksekusi sekali setelah disiasikan,fungsi ini tidak akan diekskusi ulang kembali
  //bahkan setelah berpindah pindah halaman pun ,fungsi ini akan di eksekusi kembali ketika aplikasi
  ///di destroy dan di buka kembali
  @override
  void onInit() {
    this.initCartBox();
    // TODO: implement onInit
    super.onInit();
  }

}