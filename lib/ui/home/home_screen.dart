import 'package:badges/badges.dart';
import 'package:book_store/mixins/user_session.dart';
import 'package:book_store/routes.dart';
import 'package:book_store/ui/home/home_controller.dart';
import 'package:book_store/ui/home/tabs/tab_cart/cart_tab.dart';
import 'package:book_store/ui/home/tabs/tab_history/history_tab.dart';
import 'package:book_store/ui/home/tabs/tab_list_book/list_book_tab.dart';
import 'package:book_store/ui/home/tabs/tab_search_book/search_book_tab.dart';
import 'package:book_store/ui/login/login_controller.dart';
import 'package:book_store/ui/splash_screen/splash_screen_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// nahh disini saya akan menjelaskan penggunaan Obx yang benar jadi kita tidak bisa
/// menambahkan Obx di dalam Obx dalam controller yang sama
/// contohnya seperti ini
/// Obx(
///  diisi oleh ControllerExample1,
///  Obx(
///  diisi oleh ControllerExample1 lagi
///  )
/// )
/// nah contoh seperti ini tidak diperbolehkan dalam GetX nanti screen akan berubah menjadi merah
/// kalau yang diperbolehkan seperti ini
/// Obx(
/// diisi oleh ControllerExample1
///  Obx(
///    diisi oleh ControllerExample2
///    Obx(
///      diisi oleh ControllerExample3
///    )
///  )
/// )
/// nahh yang seperti ini diperbolehkan
/// selama widget dibungkus oleh Obx dan ada widget yang diisi
/// oleh Variable Observable dari Controller GetX UI pasti akan diupdate
class HomeScreen extends StatelessWidget {
  HomeController homeControllerl;
  LoginController loginController;
  List<Widget>list_widget=[
    ListBookTab(),
    SearchBookTab(),
    CartTab(),
    HistoryTab()
  ];

  @override
  Widget build(BuildContext context) {
    ///inisiasi controller
    homeControllerl=Get.find<HomeController>();
    ///kita akan mengambil nilai session user dari splashController
    loginController=Get.find<LoginController>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Mr.Stein's Book Store",style: TextStyle(fontFamily:"Pacifico" ),),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value){
             if(value==2){
               ///hapus session dan delete history route
               UserSession().deleteUser().then((value){
                 ///jika ingin menghapus cart juga
                 homeControllerl.deleteAllCart();
                 Get.offAllNamed(RouterGenerator.routeSplash);
               });
             }
            },
            itemBuilder: (context)=>[
              PopupMenuItem(
                  value: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loginController.userSession.value["name"],
                        style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text(loginController.userSession.value["email"],
                        style: TextStyle(),)
                    ],
                  )
              ),
              PopupMenuItem(
                value: 2,
                child: Column(
                  children: [
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.power_settings_new_outlined,size: 20,color: Colors.black,),
                        SizedBox(width: 3,),
                        Text("Logout")
                      ],
                    ),
                  ],
                ),
              )

            ],
          )
        ],
      ),
      // widget Obx ini berfungsi untuk listen variable observable dari controller
      //dan mengupdate value widget yang sudah diisi variable observable dari controller
      body: Obx(()=>list_widget[homeControllerl.currentIndex.value]),
      bottomNavigationBar: Obx(
          ()=> BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 5,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            backgroundColor: Colors.blue,
            currentIndex: homeControllerl.currentIndex.value,
            onTap: (index){
             homeControllerl.changeIndex(index);
            },
              items: [
                new BottomNavigationBarItem(
                  icon: Icon(Icons.book,color: Colors.white,),
                  title: Text('List Book',style: TextStyle(color: Colors.white,)),
                ),
                new BottomNavigationBarItem(
                  icon: Icon(Icons.search,color: Colors.white,),
                  title: Text('Find Book',style: TextStyle(color: Colors.white,)),
                ),
                ///disini kita akan mengambil dan mengakses variable list_book_cart dari homeController
                ///supaya kita dapat menambahkan badge pada BottomNavigationItem berisi tentang
                ///jumlah buku yang sudah ada di cart juga akan listen ketika
                ///cart tersebut berkurang atau bertambah
                new BottomNavigationBarItem(
                  icon: homeControllerl.list_cart_book.isEmpty?
                  Icon(Icons.shopping_cart,color: Colors.white,):
                  Badge(
                    badgeColor: Colors.red,
                    badgeContent: Text(homeControllerl.list_cart_book.length.toString(),style: TextStyle(color: Colors.white),),
                    child: Icon(Icons.shopping_cart,color: Colors.white,),
                  ),
                  title: Text('Cart',style: TextStyle(color: Colors.white,)),
                ),
                new BottomNavigationBarItem(
                  icon: Icon(Icons.payment,color: Colors.white,),
                  title: Text('Transaction',style: TextStyle(color: Colors.white,)),
                ),
              ]
        ),
      ),
    );
  }
}
