import 'dart:convert';
import 'package:hive/hive.dart';
part 'book.g.dart';
// wajib menggunakan .g.dart
// misalkan kita akan membuat class Person ,nah wajib
//dibuat part 'class.g.dart'

List<Book> bookFromJson(String response){
  final jsonData = json.decode(response);
  final data=jsonData["data"];
  return new List<Book>.from(data.map((x) => Book.fromJson(x)));
}

///untuk simpan class ke Hive diperlukan @HiveType(typeId : id_type)
///jadi kl ada class yang ingin dibuat dan perlu disimpan ke dalam Hive lakukan Annotation tersebut
///tiap class yang dibuat harus berbeda typeId nya tidak boleh sama
///
/// juga masukkan annotation HiveField sesuai urutan Attribute class
/// setelah dibuat annotation HiveType dan HiveField dan juga menambah kan part 'nama_kelas.g.dart'
/// ketikan command di terminal flutter packages pub run build_runner build
/// untuk lebih jelas lagi penggambarannya silahkan liat di Tutorial Youtube Hive Flutter
/// Erico Darmawan
@HiveType(typeId: 0)
class Book{
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  String author;
  @HiveField(4)
  int price;
  @HiveField(5)
  String photo;
  @HiveField(6)
  String publisher;
  @HiveField(7)
  int qty;

  Book({
    this.id,
    this.author,
    this.description,
    this.price,
    this.title,
    this.photo,
    this.publisher,
    this.qty
  });
  //

  factory Book.fromJson(Map<String,dynamic> json)=>new Book(
    id   :   json["id"],
    title: json["title"],
    description: json["description"],
    author:  json["author"],
    price: json["price"],
    photo: json["photo"],
    qty: json["qty"]!=null?json["qty"]:0,
    publisher: json["publisher"],
  );
  Map<String,dynamic>toJson()=>{
    "id" : id,
    "title" : title,
    "description":description,
    "author":author,
    "price":price,
    "photo":photo,
    "qty":qty,
    "publisher":publisher
  };
  //
  // Map<String,dynamic>toJson()=>{
  //   "id" : id,
  //   "title" : title,
  //   "description":description,
  //   "author":author,
  //   "price":price,
  //   "photo":photo,
  //   "publisher":publisher
  // };

}