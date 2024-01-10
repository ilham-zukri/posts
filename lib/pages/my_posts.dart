import 'package:flutter/material.dart';
import 'package:posts/data_classes/post.dart';
import 'package:posts/widgets/post_container.dart';

import '../services.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({super.key});

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  int page = 1;
  late int lastPage;
  List posts = [];
  int postsLength = 0;
  bool isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    fetchPosts();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future<void> fetchPosts({bool isRefresh = false}) async {
    Map? data = await Services.getMyPosts();
    if (data == null) {
      posts = [];
      return;
    }
    List<Post> fetchedPosts = data['data'].map<Post>((post) {
      return Post(
        title: post['title'],
        content: post['content'],
        createdAt: post['created_at'],
        creator: post['user'],
        updatedAt: post['updated_at'],
      );
    }).toList();
    if (isRefresh) {
      posts = fetchedPosts;
    } else {
      posts += fetchedPosts;
    }
    setState(() {
      posts;
      postsLength = posts.length;
      lastPage = data['meta']['last_page'];
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if(postsLength == 0){
      return const Center(
        child: Text("Post anda akan tampil disini"),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        page = 1;
        fetchPosts(isRefresh: true);
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: isLoadingMore ? postsLength + 1 : postsLength,
        itemBuilder: (context, index) {
          if(index < postsLength){
            return Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                postContainerBuilder(
                  post: posts[index],
                  size: size,
                ),
                if(index == postsLength - 1)
                  const SizedBox(
                    height: 16,
                  )
              ],
            );
          }else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      )
    );
  }

  Future <void> _scrollListener() async{
    if (isLoadingMore) return;
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (page < lastPage) {
        setState(() {
          isLoadingMore = true;
        });
        page++;
        await fetchPosts();
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }
}
