import 'package:http/http.dart' as http;
import 'package:book_store/mixins/server.dart';

class AuthRepository{
  var url=Server.url;
// silahkan liat di dokumentasi API  tentang parameter
  // dan response
  Future<String> LoginUser(String email, String password) async {
    var res = await http.post(url+"/login", body : {
      "email"       : email,
      "password"    : password,
    });
    print("hasil request login "+res.body);
    if (res.statusCode == 200) {
      return res.body;
    }else{
      throw Exception();
    }
  }

  Future<String>registerUser(String name, String email, String password,String confirmation_password) async {
    var res = await http.post(Uri.encodeFull(url+"/register"), body : {
      "name"        : name,
      "email"       : email,
      "password"    : password,
      "confirmation_password":confirmation_password,
    });

    if (res.statusCode == 200) {
      return res.body;
    }else{
      throw Exception();
    }
  }

}