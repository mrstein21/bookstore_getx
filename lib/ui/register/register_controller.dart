import 'dart:convert';

import 'package:book_store/mixins/user_session.dart';
import 'package:book_store/repository/auth_repository.dart';
import 'package:book_store/routes.dart';
import 'package:book_store/ui/login/login_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RegisterController extends GetxController{
  ///variable ini tidak bertipe observable karena tidak akan
  ///di listen update oleh UI di halaman register dan di halaman register hanya variable
  ///isObscure dan isObscure2 yang dibungkus
  ///widget Obx untuk listen update variable observable
  ProgressDialog progressDialog;
  String email="";
  String password="";
  String name="";
  String confirmation_password="";
  AuthRepository authRepository=Get.find<AuthRepository>();

  ///akses login controller supaya kita bisa mengisi ke variable userSession
  LoginController loginController=Get.find<LoginController>();

  var isObscured=true.obs;
  var isObscured2=true.obs;

  void obsucureEvent(){
    if(isObscured==true){
      isObscured(false);
    }else{
      isObscured(true);
    }
  }

  void obsucureEvent2(){
    if(isObscured2==true){
      isObscured2(false);
    }else{
      isObscured2(true);
    }
  }

  /// inisiasi init progressdialog karena untuk progress dialog diperlukan
  /// context supaya bisa digunakan
  void initProgress(BuildContext context){
    progressDialog=new ProgressDialog(context,isDismissible: false);
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void register(var formKey){
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      progressDialog.style(message: "Loading...");
      progressDialog.show();
      authRepository.registerUser(name, email, password, confirmation_password)
          .then((value) {
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
            UserSession().saveUser(user).then((value) {
              ///binding variable ke variable userSession pada loginController
              ///supaya bisa diakses di berbagai controller getX serta widget
              loginController.userSession.value = value;

              ///langsung navigasi ke home
              Get.offNamed(RouterGenerator.routeHome);
            });
          }else{
             Get.snackbar("Pesan", json_decode["message"]);
          }
        });
      }).catchError((err, track) {
        progressDialog.hide().whenComplete(() {
          print("kesalahan register " + err.toString());
          print("kesalahan register " + track.toString());
          Get.snackbar("Pesan", "Terjadi kesalahan server");
        });
      });
    }
  }
}