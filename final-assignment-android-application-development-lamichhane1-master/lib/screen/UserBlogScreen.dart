import 'package:flutter/material.dart';

import 'package:blog_app/blog/Blogs.dart';

class UserBlogScreen extends StatelessWidget {
  static const routeName = '/user-blog-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 23, 160, 170),
        title: Text(
          "My Blogs",
        ),
        centerTitle: true,
      ),
      body: Blogs(
        url: "/blogPost/getUserBlogs",
      ),
    );
  }
}
