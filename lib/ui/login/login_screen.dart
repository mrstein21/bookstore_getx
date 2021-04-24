import 'package:book_store/routes.dart';
import 'package:book_store/ui/login/login_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
 LoginController loginController;
 //untuk bertipe GlobalKey formKey tidak ditaruh di controller getX karena rawan terjadi
 //error duplicate GlobalKey
 var formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ///inisiasi login controller
    loginController=Get.find<LoginController>();
    ///eksekusi inisiasi progress dialog
    loginController.initProgress(context);
    return Scaffold(
      body:Center(
        child: Container(
          padding: EdgeInsets.all(30),
          child: ListView(
            children: [
              ///variable dari l controller getX bisa langsung diakses..//dengan cara
              ///nama_controller.nama_variable
              Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child:Text("Mr.Stein's Book Store",textAlign:TextAlign.center,style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontFamily: "Pacifico",
                          fontSize: 40))
                    ),
                    SizedBox(height:50),
                    TextFormField(
                      validator: (String value){
                        if(value.isEmpty){
                          return "Silahkan isi email anda";
                        }
                        return null;
                      },
                      onSaved: (String value){
                        loginController.email=value;
                      },
                      style:  new TextStyle(
                        fontFamily: "Poppins",
                      ),
                      decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(),
                          )
                      ),
                    ),
                    SizedBox(height:30),
                    Obx(
                      ()=> TextFormField(
                        obscureText: loginController.isObscured.value,
                        validator: (String value){
                          if(value.isEmpty){
                            return "Silahkan isi password anda";
                          }
                          return null;
                        },
                        onSaved: (String value){
                          loginController.password=value;
                        },
                        style:  new TextStyle(
                          fontFamily: "Poppins",
                        ),
                        decoration: InputDecoration(
                            suffixIcon:
                                InkWell(
                                  onTap: (){
                                    loginController.obsucureEvent();
                                  },
                                  child: loginController.isObscured==true?
                                   Icon(Icons.visibility):Icon(Icons.visibility_off)
                                  ,
                                ),
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: new BorderSide(),
                            )
                        ),
                      ),
                    ),
                    SizedBox(height:30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: RaisedButton(
                        color: Colors.blue,
                        onPressed: (){
                          //eksekusi fungsi login
                          loginController.login(formKey);
                        },
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                        elevation: 4.0,
                        child: Text("Login",style:TextStyle( color: Colors.white,fontSize: 15.0,)),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Center(
                      child: InkWell(
                        onTap: (){
                            Get.offNamed(RouterGenerator.routeRegister);
                         },
                        child: Text("Register Now",style:TextStyle( color: Colors.blue,fontSize: 15.0,)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ) ,
    );
  }
}
