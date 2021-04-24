import 'package:hive/hive.dart';

/// class untuk mengelola (menyimpan dan mendapatkan nilai session user)
class UserSession{
  //nama box untuk Hivenya
  static String box_name="user_box";
  //nama key untuk Hivenya
  static String key_name="current_user";
  ///box untuk hive
  Box userBox;


  ///syntax untuk save user session dan return nilai
  Future<Map<String,dynamic>> saveUser(Map<String,dynamic>body)async{
    //sebelum akses hive wajib untuk panggil fungsi open box supaya tidak null
    await Hive.openBox(box_name);
    ///akses box dengan key box_name
    userBox=Hive.box(box_name);
    //simpan nilai user dengan key_name dan paramternya
    userBox.put(key_name, body);
    Map<String, dynamic>user =Map<String,dynamic>.from(userBox.get(key_name));
    return user;
  }

  ///syntax untuk mendapatkan user session;
  Future<Map<String,dynamic>>getUser()async{
    await Hive.openBox(box_name);
    ///akses box dengan key box_name
    userBox=Hive.box(box_name);
    //mendapatkan nilai user dengan mengakses userBox dengan kata key_name
    if(userBox.get(key_name)!=null) {
      Map<String, dynamic>user =Map<String,dynamic>.from(userBox.get(key_name));
      return user;
    }else {
      return null;
    }
  }

  Future<void> deleteUser()async{
    await Hive.openBox(box_name);
    ///akses box dengan key box_name
    userBox=Hive.box(box_name);
    userBox.delete(key_name);
  }


}