import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'news.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  List<News> newNews = [];
  void getNews() async {
    Response response = await get(
        'https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty');
    List storyId = jsonDecode(response.body);
    storyId = storyId.sublist(0, 20);

    for (var id in storyId) {
      Response storyResponse = await get(
          'https://hacker-news.firebaseio.com/v0/item/$id.json?print=pretty');
      Map story = jsonDecode(storyResponse.body);
      String content = story['title'];
      String by = story['by'];
      String url = story['url'];
      News newsnew = new News(content, by, url);
      newNews.add(newsnew);
    }

    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'news': newNews,
    });
  }

  @override
  void initState() {
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('HackerNews'),
          centerTitle: true,
        ),
        body: Center(
          child: SpinKitRotatingCircle(
            color: Colors.amber,
            size: 50.0,
          ),
        ));
  }
}
