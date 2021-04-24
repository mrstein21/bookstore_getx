import 'package:book_store/repository/auth_repository.dart';
import 'package:book_store/repository/book_repository.dart';
import 'package:book_store/repository/transaction_repository.dart';
import 'package:book_store/ui/detail_history/detail_history_controller.dart';
import 'package:book_store/ui/home/home_controller.dart';
import 'package:book_store/ui/home/tabs/tab_cart/cart_controller.dart';
import 'package:book_store/ui/home/tabs/tab_history/history_controller.dart';
import 'package:book_store/ui/home/tabs/tab_list_book/list_book_controller.dart';
import 'package:book_store/ui/home/tabs/tab_search_book/search_book_controller.dart';
import 'package:book_store/ui/login/login_controller.dart';
import 'package:book_store/ui/register/register_controller.dart';
import 'package:book_store/ui/splash_screen/splash_screen_controller.dart';
import 'package:get/get.dart';

void injectDI(){
  /// untuk injeksi class urutan penginjeksian berpengaruh jika class yang diinjeksi akan mengakses
  /// class yang diinjeksi lainnya
  /// contoh LoginController tidak bisa mengakses RegisterController
  /// sementara Register Controller bisa mengakses Login Controller
  /// demikian juga dengan AuthRepository tidak bisa mengakses LoginController
  /// sementara LoginController bisa mengakses AuthRepository
  /// kl ingin mengabaikan aturan urutan injeksi,bisa memanggil class yang diinjeksi dengan
  /// Get.put
  /// mungkin bisa eksplor lebih lanjut lagi :D
  Get.put(AuthRepository());
  Get.put(BookRepository());
  Get.put(TransactionRepository());

  /// injection untuk controller getX wajib hukumnya
  Get.put(LoginController());
  Get.put(ListBookController());
  Get.put(HomeController());
  Get.put(CartController());
  Get.put(SplashScreenController());
  Get.put(SearchBookController());
  Get.put(HistoryController());
  Get.put(DetailHistoryController());
  Get.put(RegisterController());

  //,,,,

}