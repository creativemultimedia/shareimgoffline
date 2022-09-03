import 'dart:convert';
import 'dart:io';
import 'package:demo_img/second.dart';
import 'package:external_path/external_path.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

import 'dropdowndemo.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ImagePicker _picker = ImagePicker();
  XFile? image;
  Directory? d;
  bool t = false;
   late Database database;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db_create();
    createfolder();
  }
  db_create()
  async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'cdmi.db');
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE student (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, contact TEXT,image TEXT)');
        });
  }

  createfolder()
  async {
    var downloadfolderpath = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    d=Directory("$downloadfolderpath/myapp");
    if(!await d!.exists())
      {
        await d!.create();
        print("Folder created");
      }
    else
      {
        print("Folder already exist");
      }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("select camera or gallery"),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              image = await _picker.pickImage(
                                  source: ImageSource.camera);
                              setState(() {
                                t = true;
                              });
                              Navigator.pop(context);
                            },
                            child: Text("Camera")),
                        TextButton(
                            onPressed: () async {
                              image = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              setState(() {
                                t = true;
                              });
                              Navigator.pop(context);
                            },
                            child: Text("Gallery")),
                      ],
                    );
                  },
                );
              },
              child: Text("Select Image")),
          Container(
            width: 100,
            height: 100,
            child: (t == true)
                ? Image.file(File(image!.path))
                : Icon(Icons.supervised_user_circle),
          ),
          ElevatedButton(onPressed: () async {
            String name="shyam";
            String contact="76767";
            DateTime date=DateTime.now();
            String imgname="Img_${date.year}${date.month}${date.day}${date.hour}${date.minute}${date.second}${date.millisecond}.jpg";
            File f=File("${d!.path}/${imgname}");
            if(!await f.exists())
              {
                await f.create();
                await f.writeAsBytes(await image!.readAsBytes());
                print("image created");
              }

          //   String img;
          //   img=base64Encode(await image!.readAsBytes());
          //
            String sql="insert into student values(null,'$name','$contact','${f.path}')";
            print(sql);
            int r_id;
            r_id=await database.rawInsert(sql);
          print(r_id);
          
          }, child: Text("Insert Data")),
          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Second(database);
            },));
          }, child: Text("ViewData"))
        ],
      )),
    );
  }
}
