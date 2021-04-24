import 'package:book_store/mixins/server.dart';
import 'package:book_store/mixins/utils.dart';
import 'package:book_store/model/book.dart';
import 'package:book_store/ui/detail_history/detail_history_controller.dart';
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
class DetailHistoryScreen extends StatelessWidget {
  String trans_id;
  DetailHistoryScreen({
     this.trans_id
   });
  DetailHistoryController controller;
  @override
  Widget build(BuildContext context) {
    //inisisasi controller
    controller=Get.find<DetailHistoryController>();
    controller.getDetail(trans_id);
    // widget Obx ini berfungsi untuk listen variable observable dari controller
    //dan mengupdate value widget yang sudah diisi variable  observable dari controller
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction Detail"),
      ),
      body: Container(
        child: Obx(
            ()=>
            controller.isLoading==true?Utils().buildLoading():
            ListView(
              children: [
                _buildField("No.Transaksi", controller.total.value.toString()),
                Divider(),
                _buildField("Tanggal", controller.date.value.toString()),
                Divider(),
                Container(
                  margin: EdgeInsets.only(left: 10,bottom: 10,top: 20),
                  child:Text("Detail Book :",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black)) ,
                ),
                _buildListBook(controller.list_book),
                Divider(),
                _buildField("Total", "Rp "+controller.total.value.toString()),
                Divider(),
              ],
            )
        ),
      ),
    );
  }

  Widget _buildField(String fieldname,String value){
    return ListTile(
      title: Text("$fieldname :",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black)),
      trailing:Text(value,style:TextStyle(fontSize: 14,color: Colors.black)),
    );
  }

  Widget _buildListBook(List<Book>list){
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context,index){
          return _buildRowBook(list[index]);
        },
        separatorBuilder:(context,index){
          return Divider();
        },
        itemCount: list.length
    );
  }

  Widget _buildRowBook(Book book){
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment:MainAxisAlignment.start,
        crossAxisAlignment:CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height:60,
            width: 60,
            decoration: BoxDecoration(
                borderRadius:  new BorderRadius.circular(5.0),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image:NetworkImage(Server.url+"/book/image/"+book.photo)
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
                Text(book.title,style:TextStyle(fontWeight: FontWeight.bold,fontSize: 13),maxLines: 1,overflow: TextOverflow.ellipsis,),
                Text(book.description,style:TextStyle(fontSize: 12,),maxLines: 2,overflow: TextOverflow.ellipsis,),
                SizedBox(
                  height:10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rp "+Utils.format.format(book.price),style:TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.black)),
                    SizedBox(width: 6,),
                    Text("x "+Utils.format.format(book.qty),style:TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.black)),
                  ],
                ) ,
                SizedBox(
                  height: 7,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
