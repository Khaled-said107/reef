
class CreateCommentModel {
  final String status;
  final String message;
  final CommentData data;

  CreateCommentModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CreateCommentModel.fromJson(Map<String, dynamic> json) {
    return CreateCommentModel(
      status: json['status'],
      message: json['message'],
      data: CommentData.fromJson(json['data']),
    );
  }
}

class CommentData {
  final SimpleComment comment;

  CommentData({required this.comment});

  factory CommentData.fromJson(Map<String, dynamic> json) {
    return CommentData(
      comment: SimpleComment.fromJson(json['comment']),
    );
  }
}

class SimpleComment {
  final String id;
  final String userId;
  final String targetId;
  final String targetType;
  final String content;
  final String? parentComment;
  final String createdAt;
  final String updatedAt;

  SimpleComment({
    required this.id,
    required this.userId,
    required this.targetId,
    required this.targetType,
    required this.content,
    this.parentComment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SimpleComment.fromJson(Map<String, dynamic> json) {
    return SimpleComment(
      id: json['_id'],
      userId: json['userId'],
      targetId: json['targetId'],
      targetType: json['targetType'],
      content: json['content'],
      parentComment: json['parentComment'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
