import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Post {
  final String title;
  final String content;
  final String author;

  Post(this.title, this.content, this.author);
}

// In your controller file (using GetX for state management)
class PostController extends GetxController {
  final posts = <Post>[].obs;

  void fetchPosts() {
    // You would fetch posts from Firebase Firestore here
    // For now, let's add some dummy data
    posts.value = [
      Post('Post 1', 'Content for post 1', 'User A'),
      Post('Post 2', 'Content for post 2', 'User B'),
      // Add more posts here
    ];
  }
}

// In your UI file
class PostListPage extends StatelessWidget {
  final PostController postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
                  () => ListView.builder(
                itemCount: postController.posts.length,
                itemBuilder: (context, index) {
                  final post = postController.posts[index];
                  return ListTile(
                    title: Text(post.title),
                    subtitle: Text(post.content),
                    trailing: TextButton(
                      onPressed: () {
                        // Logic to handle taking up the work
                      },
                      child: Text('Take Work'),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the page for creating a new post
              },
              child: Text('Add Post'),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    GetMaterialApp(
      home: PostListPage(),
    ),
  );
}
