class UserProfile {
  const UserProfile({
    required this.uid,
    required this.displayName,
    required this.emojiIndex,
    required this.createdAt,
  });

  final String uid;
  final String displayName;
  final int emojiIndex;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'displayName': displayName,
    'emojiIndex': emojiIndex,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'],
      displayName: json['displayName'],
      emojiIndex: json['emojiIndex'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  UserProfile copyWith({
    String? uid,
    String? displayName,
    int? emojiIndex,
    DateTime? createdAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      emojiIndex: emojiIndex ?? this.emojiIndex,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
