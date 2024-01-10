import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:posts/pages/my_posts.dart';
import 'package:posts/pages/posts_page.dart';
import 'package:posts/widgets/custom_text_field.dart';

import '../loading_overlay.dart';
import '../services.dart';
import 'login_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  bool isLoading = false;
  late final TabController _tabController;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
                title: const Text("Main Page"),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      showConfirmationDialog(context);
                    },
                  )
                ],
                bottom: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(
                      text: "Posts",
                    ),
                    Tab(
                      text: "My Posts",
                    ),
                  ],
                )),
            body: TabBarView(
              controller: _tabController,
              children: const [
                PostsPage(),
                MyPosts(),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showCreatePostDialog(context);
              },
              child: const Icon(Icons.add),
            )),
        loadingOverlay(isLoading, context)
      ],
    );
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah anda yakin?"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Tidak",
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                sendLogout();
                Navigator.of(context).pop();
              },
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendLogout() async {
    setState(() {
      isLoading = true;
    });
    try {
      Response? response = await Services.logout();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blue,
            content: Text(
              response!.data['message'],
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blue,
            content: Text(
              e.toString(),
            ),
          ),
        );
      }
    }
  }

  void showCreatePostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create Post"),
          scrollable: true,
          contentPadding: const EdgeInsets.all(16),
          actionsPadding: const EdgeInsets.all(16),
          content: Column(
            children: [
              customTextField(
                label: 'Title',
                controller: _titleController,
                obscureText: false,
              ),
              const SizedBox(
                height: 8,
              ),
              customTextField(
                label: "Content",
                controller: _bodyController,
                obscureText: false,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                createPost();
                Navigator.of(context).pop();
              },
              child: const Text(
                "Post",
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> createPost() async {
    String title = _titleController.text.trim();
    String content = _bodyController.text.trim();
    setState(() {
      isLoading = true;
    });
    try {
      Response? response =
          await Services.createPost(title: title, content: content);
      setState(() {
        isLoading = false;
        _titleController.clear();
        _bodyController.clear();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blue,
            content: Text(
              response!.data['message'],
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blue,
            content: Text(
              e.toString(),
            ),
          ),
        );
      }
    }
  }
}
