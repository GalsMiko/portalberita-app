import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'profile.dart';
import 'home.dart';
import 'group.dart';

class NewsHomePage extends StatefulWidget {
  final String username;

  NewsHomePage({required this.username});

  @override
  _NewsHomePageState createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  List<dynamic> _articles = [];

  Future<void> _fetchNewsData() async {
    final apiKey =
        'ade2579b269441498c1ca01575cbdac3'; // Ganti dengan kunci API berita yang valid
    final url =
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final newsData = jsonDecode(response.body);
      final articles = newsData['articles'];

      setState(() {
        _articles = articles;
      });
    } else {
      setState(() {
        _articles = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Portal Berita | Welcome, ${widget.username}'),
      ),
      body: ListView.builder(
        itemCount: _articles.length,
        itemBuilder: (context, index) {
          final article = _articles[index];

          return ListTile(
            leading: article['urlToImage'] != null
                ? Image.network(article['urlToImage'])
                : Container(),
            title: Text(article['title']),
            subtitle: Text(article['description']),
            onTap: () {
              // Navigasi ke halaman detail berita
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailPage(article: article),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Indeks halaman yang terpilih (home)
        onTap: (index) {
          if (index == 0) {
  // Pergi ke halaman profil
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProfilePage(username: widget.username),
    )
  );
          } else if (index == 2) {
            // Pergi ke halaman kelompok
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupPage(),
              ),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Group',
          ),
        ],
      ),
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final dynamic article;

  const NewsDetailPage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            article['urlToImage'] != null
                ? Image.network(article['urlToImage'])
                : Container(),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    article['title'],
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    article['description'],
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Source: ${article['source']['name']}',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Published: ${article['publishedAt']}',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Author: ${article['author']}',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Content: ${article['content']}',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
