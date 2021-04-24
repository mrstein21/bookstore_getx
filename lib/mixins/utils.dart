import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils{
  //untuk separator angka
  static var format = new NumberFormat.currency(decimalDigits: 0,
      symbol: "");

  //daripada kita buat loading pada screen terus
  //lebih baik kita jadikan fungsi supaya tidak menulis kembali ulang kode...
  Widget buildLoading(){
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildMessage(IconData iconData,String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              color: Colors.grey,
              size: 70,
            ),
            Text(
              message,
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

}