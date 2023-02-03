class Post {
  final String id;
  final String title;
  final String? link;
  final String? description;
  final String communityName;
  final String communityAvatar;
  final String userName;
  final String userUid;
  final String type;
  final int commentCount;
  final DateTime createdAt;
  final List<String> upVotes;
  final List<String> downVotes;
  final List<String> awards;
  Post({
    required this.id,
    required this.title,
    this.link,
    this.description,
    required this.communityName,
    required this.communityAvatar,
    required this.userName,
    required this.userUid,
    required this.type,
    required this.commentCount,
    required this.createdAt,
    required this.upVotes,
    required this.downVotes,
    required this.awards,
  });


  Post copyWith({
    String? id,
    String? title,
    String? link,
    String? description,
    String? communityName,
    String? communityAvatar,
    String? userName,
    String? userUid,
    String? type,
    int? commentCount,
    DateTime? createdAt,
    List<String>? upVotes,
    List<String>? downVotes,
    List<String>? awards,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      description: description ?? this.description,
      communityName: communityName ?? this.communityName,
      communityAvatar: communityAvatar ?? this.communityAvatar,
      userName: userName ?? this.userName,
      userUid: userUid ?? this.userUid,
      type: type ?? this.type,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
      upVotes: upVotes ?? this.upVotes,
      downVotes: downVotes ?? this.downVotes,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'link': link,
      'description': description,
      'communityName': communityName,
      'communityAvatar': communityAvatar,
      'userName': userName,
      'userUid': userUid,
      'type': type,
      'commentCount': commentCount,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'upVotes': upVotes,
      'downVotes': downVotes,
      'awards': awards,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      title: map['title'] as String,
      link: map['link'] != null ? map['link'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      communityName: map['communityName'] as String,
      communityAvatar: map['communityAvatar'] as String,
      userName: map['userName'] as String,
      userUid: map['userUid'] as String,
      type: map['type'] as String,
      commentCount: map['commentCount'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      upVotes: List<String>.from(map['upVotes']),
      downVotes: List<String>.from(map['downVotes']),
      awards: List<String>.from((map['awards'])),
    );
  }

  @override
  String toString() {
    return 'Post(id: $id, title: $title, link: $link, description: $description, communityName: $communityName, communityAvatar: $communityAvatar, userName: $userName, userUid: $userUid, type: $type, commentCount: $commentCount, createdAt: $createdAt, upVotes: $upVotes, downVotes: $downVotes, awards: $awards)';
  }

}
