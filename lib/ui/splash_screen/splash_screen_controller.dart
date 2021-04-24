import 'dart:async';

import 'package:book_store/mixins/user_session.dart';
import 'package:book_store/routes.dart';
import 'package:book_store/ui/login/login_controller.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController{
  ///langsung navigasi ke home
  ///akses login controller supaya kita bisa mengisi ke variable userSession
  LoginController loginController=Get.find<LoginController>();
  ///cek session user
    startSplashScreen() async {
      UserSession().getUser().then((value) {
        var duration = const Duration(seconds: 2);
        return Timer(duration, () {
          if (value == null) {
            Get.offNamed(RouterGenerator.routeLogin);
          } else {
               //jika user session ada maka
                //  binding variable ke variable userSession pada loginController
              ///supaya bisa diakses di berbagai controller getX serta widget
              loginController.userSession.value=value;
              ///langsung navigasi ke home
              Get.offNamed(RouterGenerator.routeHome);
          }
        });
      });
    }
}