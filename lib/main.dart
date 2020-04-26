import 'package:flutter/material.dart';

import 'news.dart';
import 'package:url_launcher/url_launcher.dart';
import 'loading.dart';

void main() => runApp(MaterialApp(routes: {
      '/': (context) => Loading(),
      '/home': (context) => Home(),
    }));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};

  List<News> news = [];
  Future<void> _launched;

  Future<void> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    //print(data);
    news = data['news'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('HackerNews'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Text('Top Stories',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
          SizedBox(
            height: 15,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: news.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Card(
                      margin: EdgeInsets.all(5),
                      child: Column(
                          //mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            //SizedBox(height: 15),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                news[index].content,
                              ),
                            ),

                            //SizedBox(height: 15),
                            FlatButton(
                                color: Colors.grey[500],
                                onPressed: () {
                                  _launched =
                                      _launchInWebViewOrVC(news[index].url);
                                },
                                child: Text('Read More'))
                          ]),
                    );
                  }))
        ],
      ),
      floatingActionButton: FlatButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/');
        },
        child: Text('refresh'),
        color: Colors.amber,
        //textColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
