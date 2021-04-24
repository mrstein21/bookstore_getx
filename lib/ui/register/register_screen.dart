import 'package:book_store/ui/register/register_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  RegisterController registerController;
  //untuk bertipe GlobalKey formKey tidak ditaruh di controller getX karena rawan terjadi
  //error duplicate GlobalKey
  var formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    registerController=Get.find<RegisterController>();
    registerController.initProgress(context);
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
                          return "Silahkan isi nama anda";
                        }
                        return null;
                      },
                      onSaved: (String value){
                        registerController.name=value;
                      },
                      style:  new TextStyle(
                        fontFamily: "Poppins",
                      ),
                      decoration: InputDecoration(
                          labelText: "Nama",
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(),
                          )
                      ),
                    ),
                    SizedBox(height:30),
                    TextFormField(
                      validator: (String value){
                        if(value.isEmpty){
                          return "Silahkan isi email anda";
                        }
                        return null;
                      },
                      onSaved: (String value){
                        registerController.email=value;
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
                        obscureText: registerController.isObscured.value,
                        validator: (String value){
                          if(value.isEmpty){
                            return "Silahkan isi password anda";
                          }
                          return null;
                        },
                        onSaved: (String value){
                          registerController.password=value;
                        },
                        style:  new TextStyle(
                          fontFamily: "Poppins",
                        ),
                        decoration: InputDecoration(
                            labelText: "Password",
                            suffixIcon:
                            InkWell(
                              onTap: (){
                                registerController.obsucureEvent();
                              },
                              child: registerController.isObscured==true?
                              Icon(Icons.visibility):Icon(Icons.visibility_off),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: new BorderSide(),
                            )
                        ),
                      ),
                    ),
                    SizedBox(height:30),
                    Obx(
                          ()=> TextFormField(
                        obscureText: registerController.isObscured2.value,
                        validator: (String value){
                          if(value.isEmpty){
                            return "Silahkan isi konfirmasi password anda";
                          }
                          return null;
                        },
                        onSaved: (String value){
                          registerController.confirmation_password=value;
                        },
                        style:  new TextStyle(
                          fontFamily: "Poppins",
                        ),
                        decoration: InputDecoration(
                            labelText: "Konfirmasi Password",
                            suffixIcon:
                            InkWell(
                              onTap: (){
                                registerController.obsucureEvent2();
                              },
                              child: registerController.isObscured2==true?
                              Icon(Icons.visibility):Icon(Icons.visibility_off),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: new BorderSide(),
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: RaisedButton(
                        color: Colors.blue,
                        onPressed: (){
                          //eksekusi fungsi register
                          registerController.register(formKey);
                        },
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                        elevation: 4.0,
                        child: Text("Register",style:TextStyle( color: Colors.white,fontSize: 15.0,)),
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
