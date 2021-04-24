import 'dart:convert';

import 'package:book_store/mixins/user_session.dart';
import 'package:book_store/repository/auth_repository.dart';
import 'package:book_store/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LoginController extends GetxController{
  ///variable ini tidak bertipe observable karena tidak akan
  ///di listen update oleh UI di halaman login dan hanya variable isObscure yang akan di listen oleh
  ///widget Obx
  ProgressDialog progressDialog;
  String email="";
  String password="";
  AuthRepository authRepository=Get.find<AuthRepository>();
  var isObscured=true.obs;
  var userSession=new Map<String,dynamic>().obs;

  @override
  void onInit() {
    ///
    ///
    // TODO: implement onInit
    super.onInit();
  }

  void obsucureEvent(){
    if(isObscured==true){
      isObscured(false);
    }else{
      isObscured(true);
    }
  }


  /// inisiasi init progressdialog karena untuk progress dialog diperlukan
  /// context supaya bisa digunakan
  void initProgress(BuildContext context){
    progressDialog=new ProgressDialog(context,isDismissible: false);
  }

  void login(var formKey){
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      progressDialog.style(message: "Loading...");
      progressDialog.show();
      print("email .." + email);
      print("password,,," + password);
      authRepository.LoginUser(email, password).then((value) {
        progressDialog.hide().whenComplete(() {
          ///decode json dari string response
          var json_decode = json.decode(value);
          if(json_decode["success"]=="1") {

            ///proses parsing json user dan simpen ke hive
            ///untuk proses parsing lebih baik sambil liat dokumentasi api bagian login
            ///supaya tidak bingung.
            Map<String, dynamic>user = {
              "id": json_decode["data"]["id"],
              "name": json_decode["data"]["name"],
              "email": json_decode["data"]["email"],
              "is_login": true
            };
            //simpan user..
            /// dan get user serta hasil get user di binding ke variable observable
            /// userSession supaya bisa diakses di berbagai controller getX dan widget
            UserSession().saveUser(user).then((value) {
              userSession.value = value;
              Get.offNamed(RouterGenerator.routeHome);
            });

            ///langsung navigasi ke home
          }else{
            Get.snackbar("Pesan", json_decode["message"]);
          }
        });
      }).catchError((err, track) {
        progressDialog.hide().whenComplete(() {
          print("kesalahan login " + err.toString());
          print("kesalahan login " + track.toString());
          Get.snackbar("Pesan", "Terjadi kesalahan server");
        });
      });
    }
  }

}