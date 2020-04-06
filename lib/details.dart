import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_unsplash_app/home.dart';

class DetailsPage extends StatelessWidget {
  final String title = "Details";
  final Photo photo;

  DetailsPage({Key key, this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Column(
          children: <Widget>[
            new Expanded(
                child: new Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      photo.imgFull,
                      fit: BoxFit.fitHeight,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                    ))),
            new Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(photo.title, style: Theme.of(context).textTheme.title),
                  Text('Author: ${photo.author}'),
                  Text(photo.date,
                      style: TextStyle(color: Colors.black.withOpacity(0.5))),
                ],
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ));
  }
}
