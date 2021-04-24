
import 'package:book_store/mixins/server.dart';
import 'package:book_store/mixins/utils.dart';
import 'package:book_store/model/book.dart';
import 'package:book_store/ui/home/home_controller.dart';
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

/// widget ini nantinya akan dipakai untuk
/// list book dan search book
class ItemBook extends StatelessWidget {
  HomeController homeController;
  Book book;
  ItemBook({this.book});
  String base_url=Server.url;
  @override
  Widget build(BuildContext context) {
    homeController=Get.find<HomeController>();
    return _buildRowBook(book);
  }


  Widget _buildRowBook(Book book) {
    return IntrinsicHeight(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment:MainAxisAlignment.start,
          crossAxisAlignment:CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height:90,
              width: 80,
              decoration: BoxDecoration(
                  borderRadius:  new BorderRadius.circular(5.0),
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image:NetworkImage(base_url+"/book/image/"+book.photo)
                  )
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(book.title,style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15),maxLines: 1,overflow: TextOverflow.ellipsis,),
                  Text(book.description,style:TextStyle(fontSize: 12,),maxLines: 2,overflow: TextOverflow.ellipsis,),
                  SizedBox(
                    height:10,
                  ),
                  Text("Rp "+Utils.format.format(book.price),style:TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: Colors.blue)) ,
                  SizedBox(
                    height: 7,
                  ),
                  Obx(
                      (){
                        //cek apakah buku ini ada di dalam cart
                        Book exist=homeController.list_cart_book.firstWhere((element) => element.id==
                        book.id,orElse: ()=>null);
                        //jika tidak ada
                        if(exist==null){
                          //karena buku tidak ada di dalam cart
                          //maka otomatis qty null
                          ///maka dari itu sebelum dimasukkan ke cart saya isi qty=1
                          book.qty=1;
                          return _buildAddToCart(book);
                        }else{
                          ///jika ada maka kita akan kirimkan 2 parameter
                          ///yaitu object buku yang kita ambil dari homeController yang bernama exist
                          ///dan juga object buku yang bernama book
                          return _buildQty(book, exist);
                        }
                      }
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQty(Book book,Book book_on_cart){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: ()=>homeController.deleteCart(book),
          child: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: Colors.blue,width: 1)
            ),
            child: Icon(Icons.delete,color: Colors.blue,size: 18,),
          ),
        ),
        SizedBox(width: 10,),
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
        Text(book_on_cart.qty.toString(),style: TextStyle(fontFamily: "Roboto",fontWeight: FontWeight.bold)),
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

  Widget _buildAddToCart(Book book){
    return SizedBox(
      height: 25,
      child: RaisedButton(
        color: Colors.blue,
        onPressed: (){
          homeController.updateCart(book, true);
        },
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
        elevation: 1.0,
        child: Text("Add To Cart",style:TextStyle( color: Colors.white,fontSize: 12.0,)),
      ),
    );
  }

}
