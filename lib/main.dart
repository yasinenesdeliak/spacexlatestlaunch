import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<SpaceX> fetchMission() async {
  final response =
  await http.get(Uri.https('api.spacexdata.com', 'v4/launches/latest'));

  if (response.statusCode == 200) {
    return SpaceX.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load info');
  }
}

class SpaceX {
  final String name;
  final String details;


  SpaceX( {@required this.name,this.details,});

  factory SpaceX.fromJson(Map<String, dynamic> json) {
    return SpaceX(
      name: json['name'],
      details: json['details'],

    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<SpaceX> futureSpaceX;

  @override
  void initState() {
    super.initState();
    futureSpaceX = fetchMission();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpaceX Latest Launch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('SpaceX Latest Launch'),
        ),
        body: Center(
          child: Column(
            children: [
              FutureBuilder<SpaceX>(
                future: futureSpaceX,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(snapshot.data.name,style: TextStyle(fontSize: 30),),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              ),
              SizedBox(height: 10,),
              FutureBuilder<SpaceX>(
                future: futureSpaceX,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(snapshot.data.details),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

