import 'package:book_store/mixins/server.dart';
import 'package:book_store/mixins/utils.dart';
import 'package:book_store/model/book.dart';
import 'package:book_store/ui/home/home_controller.dart';
import 'package:book_store/ui/home/tabs/tab_cart/cart_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// nahh disini saya akan menjelaskan penggunaan Obx yang benar jadi kita tidak bisa
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

class CartTab extends StatelessWidget {
  ///perlu homeController untuk mengakses variable observable list_book_cart
  ///memanggil operasi update cart serta delete cart
  HomeController homeController;
  CartController cartController;
  @override
  Widget build(BuildContext context) {
    // widget Obx ini berfungsi untuk listen variable observable dari controller
    //dan mengupdate value widget yang sudah diisi variable  observable dari controller
    homeController=Get.find<HomeController>();
    cartController=Get.find<CartController>();
    ///inisiasi progress dialog
    cartController.initDialog(context);
    return Obx(
        ()=>homeController.list_cart_book.isEmpty?
            Utils().buildMessage(Icons.shopping_cart,"Keranjang anda masih kosong")
            :
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildListCart(),
            _buildTotal(context)
          ],
        )
    );
  }


  Widget _buildTotal(BuildContext context){
    int total = 0;
    for (int i = 0; i < homeController.list_cart_book.length; i++) {
      total = total + (homeController.list_cart_book[i].qty*homeController.list_cart_book[i].price);
    }
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          boxShadow: [
          new BoxShadow(
            color: Colors.black38,
            blurRadius: 2.0,
          ),
        ],
          color: Colors.white
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total : Rp. " + Utils.format.format(total),
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 40,
            width: double.infinity,
            child: RaisedButton(
              onPressed: (){
                cartController.showDialogTransaction(context);
              },
              color: Colors.blue,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                child: Text("Checkout",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    )
                )
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListCart(){
    return Expanded(
      child: Container(
        child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider();
          },
          itemCount: homeController.list_cart_book.length,
          itemBuilder: (context, index) {
             return _buildRowCart(homeController.list_cart_book[index]);
          }
          ),
      ),
    );
  }

  Widget _buildRowCart(Book book){
    return IntrinsicHeight(
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 89,
              decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(5.0),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(Server.url +
                          "/book/image/" +
                          book.photo))),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    book.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4,),
                  Text(
                    book.description,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Rp. " + Utils.format.format(book.price),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.blue)),
                  SizedBox(
                    height: 7,
                  ),
                 _buildQty(book)
                ],
              ),
            ),
            SizedBox(
              height: 18,
              width: 50,
              child: RaisedButton(
                  color: Colors.red,
                  onPressed: () {
                    homeController.deleteCart(book);
                  },
                  shape: new CircleBorder(),
                  elevation: 4.0,
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 13,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQty(Book book){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: ()=>homeController.updateCart(book, false),
          child: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue,width: 1)
            ),
            child: Icon(Icons.remove,color: Colors.blue,size: 18,),
          ),
        ),
        SizedBox(width: 7,),
        /// disi qty yang diambil dari object buku book_on_cart
        Text(book.qty.toString(),style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.bold)),
        SizedBox(width: 7,),
        InkWell(
          onTap: ()=>homeController.updateCart(book, true),
          child: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue,width: 1)
            ),
            child: Icon(Icons.add,color: Colors.blue,size: 18,),
          ),
        )
      ],
    );
  }

}
