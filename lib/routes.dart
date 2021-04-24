import 'package:book_store/ui/detail_history/detail_history_screen.dart';
import 'package:book_store/ui/home/home_screen.dart';
import 'package:book_store/ui/login/login_screen.dart';
import 'package:book_store/ui/register/register_screen.dart';
import 'package:book_store/ui/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

class RouterGenerator{
  static const routeRegister = "/register";
  static const routeLogin = "/login";
  static const routeHome = "/home";
  static const routeSplash = "/splash";
  static const routeDetailTransaction = "/detail_transaction";


  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map<String, dynamic>params = settings.arguments as Map<String, dynamic>;
    if(settings.name==routeHome){
      return MaterialPageRoute(builder: (_) => HomeScreen());
    }else if(settings.name==routeLogin) {
      return MaterialPageRoute(builder: (_) =>
         LoginScreen());
    }else if(settings.name==routeRegister) {
      return MaterialPageRoute(builder: (_) =>
          RegisterScreen());
    }else if(settings.name==routeSplash) {
      return MaterialPageRoute(builder: (_) =>
          SplashScreen());
    }else if(settings.name==routeDetailTransaction) {
      return MaterialPageRoute(builder: (_) =>
          DetailHistoryScreen(
            trans_id: params["trans_id"],
          ));
    }
  }
}