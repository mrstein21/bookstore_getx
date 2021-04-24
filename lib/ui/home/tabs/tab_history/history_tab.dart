import 'package:book_store/mixins/utils.dart';
import 'package:book_store/model/transaction.dart';
import 'package:book_store/routes.dart';
import 'package:book_store/ui/home/tabs/tab_history/history_controller.dart';
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
class HistoryTab extends StatelessWidget {

  HistoryController controller;
  ScrollController scrollcontroller =ScrollController();
  //untuk mendeteksi bottom dari list ketika scroll list
  void onScroll(){
    double maxScroll=scrollcontroller.position.maxScrollExtent;
    double currentScroller=scrollcontroller.position.pixels;
    if(maxScroll==currentScroller){
      controller.loadMore();
    }
  }
  @override
  Widget build(BuildContext context) {
    scrollcontroller.addListener(onScroll);
    //inisiasi controller
    controller=Get.find<HistoryController>();
    controller.getTransaction();
    // widget Obx ini berfungsi untuk listen variable observable dari controller
    //dan mengupdate value widget yang sudah diisi variable  observable dari controller


    return Container(
      child: Obx(
          ()=>controller.isLoading==true?
          Utils().buildLoading():
            controller.list.isEmpty?
            Utils().buildMessage(Icons.list, "Daftar Transaksi Kosong"):
            _buildListUI(controller.isNoMoreLoad.value,controller.list)
      ),
    );
  }

  Widget _buildListUI(bool hasReachMax, List<Transaction> data) {
    return ListView.separated(
      controller: scrollcontroller,
      itemCount: (hasReachMax) ? data.length : data.length + 1,
      itemBuilder: (context, index) {
        if (index < data.length) {
          return InkWell(
            onTap: () {
                Get.toNamed(RouterGenerator.routeDetailTransaction,arguments: {
                  "trans_id":data[index].trans_id
                });
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.payment,
                    size: 40,
                    color: Colors.grey,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data[index].trans_id,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        data[index].date,
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        "Rp." + data[index].total,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.navigate_next,
                        color: Colors.grey,
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        } else {
          return Utils().buildLoading();
        }
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }


}
