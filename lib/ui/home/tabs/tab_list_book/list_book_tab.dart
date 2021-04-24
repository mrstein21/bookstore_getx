import 'package:book_store/mixins/utils.dart';
import 'package:book_store/ui/home/tabs/tab_list_book/list_book_controller.dart';
import 'package:book_store/ui/widgets/item_book.dart';
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

class ListBookTab extends StatelessWidget {
  ListBookController controller;
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
    //inisiasi controller getX
    controller=Get.find<ListBookController>();
    //eksekusi fungsi
    controller.getBook();
    //menambahkan listener ke scroll controller supaya event scroll dapat
    // di listen
    scrollcontroller.addListener(onScroll);
    return Container(
      // widget Obx ini berfungsi untuk listen variable observable dari controller
      //dan mengupdate value widget yang sudah diisi variable  observable dari controller
      child: Obx(
          ()=>controller.isLoading==true?
          Utils().buildLoading():ListView.builder(
            controller: scrollcontroller,
            itemCount: controller.isNoMoreLoad==true?controller.list.length:controller.list.length+1,
            itemBuilder: (ctx,index){
              //berikut ini adalah logika load more yang saya ambil dari
              ///pak erico darmawan di video flutter_bloc load more
              ///logikanya sama hanya beda state management saja
              if(index<controller.list.length) {
                return ItemBook(book: controller.list[index],);
              }else{
                return Utils().buildLoading();
              }
            },
          )
      ),
    );
  }
}
