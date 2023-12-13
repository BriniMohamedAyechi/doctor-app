import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class ArticleOfTheDayWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      height: 300,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueAccent, // You can customize the box color
        borderRadius: BorderRadius.circular(10),
      ),
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('articles').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final articles = snapshot.data?.docs ?? [];
          if (articles.isEmpty) {
            return Text('No articles available.');
          }

          // Get a random article
          final randomArticle = articles[Random().nextInt(articles.length)];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                randomArticle['title'] ?? 'No title available',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                randomArticle['text'] ?? 'No article available',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          );
        },
      ),
    );
  }
}
