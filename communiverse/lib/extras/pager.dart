import 'package:communiverse/models/post.dart';

class PostPage {
  final List<Post> posts;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  const PostPage({
    required this.posts,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });

    factory PostPage.fromJson(Map<String, dynamic> json) {
    final List<dynamic> postList = json['content'] ?? [];
    return PostPage(
      posts: postList.map((postJson) => Post.fromJson(postJson)).toList(),
      currentPage: json['number'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      totalItems: json['totalElements'] ?? 0,
    );
  }

  factory PostPage.empty() {
    return PostPage(
      posts: [],
      currentPage: 0,
      totalPages: 0,
      totalItems: 0,
    );
  }
}
