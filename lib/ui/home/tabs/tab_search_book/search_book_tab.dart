import 'package:book_store/mixins/utils.dart';
import 'package:book_store/ui/home/tabs/tab_search_book/search_book_controller.dart';
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


class SearchBookTab extends StatelessWidget {
  SearchBookController controller;
  var searchController=new TextEditingController();

  ScrollController scrollcontroller =ScrollController();

  //untuk mendeteksi bottom dari list ketika scroll list
  void onScroll(){
    double maxScroll=scrollcontroller.position.maxScrollExtent;
    double currentScroller=scrollcontroller.position.pixels;
    if(maxScroll==currentScroller){
      controller.loadMore();
    }
  }

  // widget Obx ini berfungsi untuk listen variable observable dari controller
  //dan mengupdate value widget yang sudah diisi variable  observable dari controller

  @override
  Widget build(BuildContext context) {
    ///inisiasi getX
    controller=Get.find<SearchBookController>();
    scrollcontroller.addListener(onScroll);
    return  Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              onChanged: (String terms){
                if(terms.isEmpty){
                  controller.iskeywordEmpty(true);
                }else{
                  controller.iskeywordEmpty(false);
                }
              },
              textInputAction: TextInputAction.done,
              controller: searchController,
              onSubmitted: (term){
                 controller.getBook(term);
              },
              style:  new TextStyle(
                fontFamily: "Poppins",
              ),
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Obx(
                          ()=>controller.iskeywordEmpty==false?
                      InkWell(
                        onTap: (){
                          controller.restartState();
                          searchController.text="";
                        },
                        child: Icon(Icons.cancel,color: Colors.red,),)
                          :Container()
                  ) ,
                  hintText: "Search keyword..",
                  border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: new BorderSide(),
                  )
              ),
            ),
          ),
          Expanded(
            child: Obx(
                (){
                  ///seleksi kondisi bool di controller
                  if(controller.isInitial==true){
                    return Utils().buildMessage(Icons.search,"Cari buku disini");
                  }else{
                    ///jika isLoading true
                    if(controller.isLoading==true){
                      return Utils().buildLoading();
                    }else{
                      //jika ada list tidak ada
                      if(controller.list.isEmpty){
                        return Utils().buildMessage(Icons.search,"Pencarian tidak ditemukan");
                      }else{
                        ///jika list ada
                        return ListView.builder(
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
                        );
                      }
                    }
                  }
                }
            ),
          )
        ],
      ),
    );
  }




}
