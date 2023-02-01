class Community {
  
  final String id;
  final String name;
  final String banner;
  final String avatar;
  final List<String> members;
  final List<String> moderators;

  Community({
    required this.id,
    required this.name,
    required this.banner,
    required this.avatar,
    required this.members,
    required this.moderators,
  });
  

  Community copyWith({
    String? id,
    String? name,
    String? banner,
    String? avatar,
    List<String>? members,
    List<String>? moderators,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      banner: banner ?? this.banner,
      avatar: avatar ?? this.avatar,
      members: members ?? this.members,
      moderators: moderators ?? this.moderators,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'banner': banner,
      'avatar': avatar,
      'members': members,
      'moderators': moderators,
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      id: map['id'] as String,
      name: map['name'] as String,
      banner: map['banner'] as String,
      avatar: map['avatar'] as String,
      members: List<String>.from(map['members']),
      moderators: List<String>.from(map['moderators']),
    );
  }

  @override
  String toString() {
    return 'Community(id: $id, name: $name, banner: $banner, avatar: $avatar, members: $members, moderators: $moderators)';
  }

}
