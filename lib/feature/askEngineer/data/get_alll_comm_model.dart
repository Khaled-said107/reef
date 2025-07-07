class GetAllCommentsModel {
  final String status;
  final int results;
  final List<Comment> comments;

  GetAllCommentsModel({
    required this.status,
    required this.results,
    required this.comments,
  });

  factory GetAllCommentsModel.fromJson(Map<String, dynamic> json) {
    return GetAllCommentsModel(
      status: json['status'],
      results: json['results'],
      comments: List<Comment>.from(
        json['data']['comments'].map((x) => Comment.fromJson(x)),
      ),
    );
  }
}

class Comment {
  final String id;
  final User user;
  final String targetId;
  final String targetType;
  final String content;
  final String createdAt;
  final String updatedAt;
  final List<Reply> replies;

  Comment({
    required this.id,
    required this.user,
    required this.targetId,
    required this.targetType,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      user: User.fromJson(json['userId']),
      targetId: json['targetId'],
      targetType: json['targetType'],
      content: json['content'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      replies: List<Reply>.from(
        json['replies'].map((x) => Reply.fromJson(x)),
      ),
    );
  }
}

class Reply {
  final String id;
  final User user;
  final String targetId;
  final String targetType;
  final String content;
  final String createdAt;
  final String updatedAt;
  final String? parentText;
  final String? parentAuthor;

  Reply({
    required this.id,
    required this.user,
    required this.targetId,
    required this.targetType,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.parentText,
    this.parentAuthor,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      id: json['_id'],
      user: User.fromJson(json['userId']),
      targetId: json['targetId'],
      targetType: json['targetType'],
      content: json['content'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      parentText: json['parentText'],
      parentAuthor: json['parentAuthor'],
    );
  }
}

class User {
  final String id;
  final String name;
  final String? profilePhoto;

  User({
    required this.id,
    required this.name,
    this.profilePhoto,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      profilePhoto: json['profilePhoto'],
    );
  }
}
