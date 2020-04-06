import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:test_unsplash_app/details.dart';
import 'package:test_unsplash_app/secret.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  final String title = "Photos list";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Photo> photos = [];

  final String apiUrl = "https://api.unsplash.com/photos/";
  Future<Secret> futureSecret = SecretLoader(secretPath: "secrets.json").load();

  Future<List<Photo>> fetchPhotos() async {
    var secret = await futureSecret;
    final response = await http.get(
        Uri.encodeFull('$apiUrl?client_id=${secret.clientId}'),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List<Photo> list = new List<Photo>();
      for (var i = 0; i < jsonResponse.length; i++) {
        list.add(Photo.fromJson(jsonResponse[i]));
      }

      return list;
    } else {
      throw Exception('Failed to load photos from unsplash');
    }
  }

  @override
  void initState() {
    super.initState();
    this.fetchPhotos().then((response) {
      setState(() {
        photos = response;
      });
    });
  }

  void handleOnTap(Photo photo) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailsPage(photo: photo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: new ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: List.generate(photos.length, (index) {
              return Center(
                child: PhotoCard(photo: photos[index], handleOnTap: (Photo val) => handleOnTap(val)),
              );
            })));
  }
}

class Photo {
  final String id;
  final String title;
  final String author;
  final String imgSmall;
  final String imgFull;
  final String date;

  const Photo({this.id, this.title, this.author, this.imgSmall, this.imgFull, this.date});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
        id: json['id'],
        imgSmall: json['urls']['thumb'],
        imgFull: json['urls']['full'],
        title: json['description'] ?? json['alt_description'],
        author: json['user']['name'],
        date: json['created_at']);
  }
}

class PhotoCard extends StatelessWidget {
  const PhotoCard(
      {Key key, @required this.handleOnTap, @required this.photo})
      : super(key: key);

  final Photo photo;
  final Function(Photo) handleOnTap;

  @override
  Widget build(BuildContext context) {


    var formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');
    var datetime = DateTime.parse(photo.date);
    final date = formatter.format(datetime);
    return new GestureDetector(
        onTap: () => handleOnTap(photo),
        child: new Card(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                new Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(photo.imgSmall)),
                new Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(photo.title,
                          style: Theme.of(context).textTheme.title),
                      Text('Author: ${photo.author}'),
                      Text(date,
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.5))),
                    ],
                  ),
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            )));
  }
}
