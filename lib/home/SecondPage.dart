import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projectma/home/homepage.dart';
import 'package:projectma/models/universities.dart';
import 'package:url_launcher/url_launcher.dart';
class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _HomePageState();
}

class _HomePageState extends State<SecondPage> {

  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  List<universities>? _itemList;
  String? _error;

  void getuniversities() async {
    try {
      setState(() {
        _error = null;
      });

      // await Future.delayed(const Duration(seconds: 3), () {});

      final response =
      await _dio.get('http://universities.hipolabs.com/search?country=United+States');

      debugPrint(response.data.toString());
      // parse
      List list = jsonDecode(response.data.toString());
      setState(() {
        _itemList = list.map((item) => universities.fromJson(item)).toList();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      debugPrint('เกิดข้อผิดพลาด: ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    getuniversities();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_error != null) {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_error!),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              getuniversities();
            },
            child: const Text('RETRY'),
          )
        ],
      );
    } else if (_itemList == null) {
      body = const Center(child: CircularProgressIndicator());
    } else {

      body = ListView.builder(
          itemCount: _itemList!.length,
          itemBuilder: (context, index) {
            var todoItem = _itemList![index];
            return Card(
                child: Padding(

                    padding: const EdgeInsets.all(8.0),

                    child: Row(children: [

                      Expanded(child: Text(todoItem.name)),
                     Expanded(child: Text(todoItem.province)),
                      Expanded(child: Text(todoItem.country)),
                      ElevatedButton(
                        onPressed: () {
                          // เมื่อปุ่มถูกกด
                          launchURL(todoItem.url.substring(1, todoItem.url.length - 1));
                        },
                        child: Text('Go to Website'),),


                    ])));
          });
    }
    handleClickAdd() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
    return Scaffold(appBar: AppBar(title: Text('List of universities in United States'),),floatingActionButton: FloatingActionButton(
        onPressed: handleClickAdd, child:Text('TH')),body: body,);
  }
  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}