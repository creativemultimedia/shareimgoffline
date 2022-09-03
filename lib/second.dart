import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Second extends StatefulWidget {
  Database database;
  Second(this.database);
  @override
  State<Second> createState() => _SecondState();
}

class _SecondState extends State<Second> {
  List<Map> l=[];
  List name=[];
  List contact=[];
  List img=[];
 Future view_data()
  async {
    String qry="select * from student";
    l=await widget.database.rawQuery(qry);
    return l;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child:
    FutureBuilder(future: view_data(),builder: (context, snapshot) {
      if(snapshot.connectionState==ConnectionState.done)
        {
           if(snapshot.hasData)
             {
               List<Map>? test=[];
               test=snapshot.data as List<Map>?;
               test!.forEach((element) { 
                 name.add(element['name']);
                 contact.add(element['contact']);
                 img.add(element['image']);
               });
             }
           return ListView.builder(itemCount: name.length,itemBuilder: (context, index) {
             return ListTile(title: Text(name[index]),subtitle: Text(contact[index]),
             leading: Image.file(img[index])
             );
           },);
        }else
          {
            return Center(child: CircularProgressIndicator(),);
          }


    },)
    ),);
  }
}
