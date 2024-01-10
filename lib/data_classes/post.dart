class Post {
  final String title;
  final String content;
  final String createdAt;
  final String creator;
  final String? updatedAt;

  Post({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.creator,
    required this.updatedAt,
  });
}
