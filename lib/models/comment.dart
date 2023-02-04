class Comment {

  final String id;
  final String text;
  final DateTime createdAt;
  final String postId;
  final String userName;
  final String userProfilePicture;
  Comment({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.postId,
    required this.userName,
    required this.userProfilePicture,
  });


  Comment copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    String? postId,
    String? userName,
    String? userProfilePicture,
  }) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      userName: userName ?? this.userName,
      userProfilePicture: userProfilePicture ?? this.userProfilePicture,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'postId': postId,
      'userName': userName,
      'userProfilePicture': userProfilePicture,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      text: map['text'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      postId: map['postId'] as String,
      userName: map['userName'] as String,
      userProfilePicture: map['userProfilePicture'] as String,
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, createdAt: $createdAt, postId: $postId, userName: $userName, userProfilePicture: $userProfilePicture)';
  }

}
