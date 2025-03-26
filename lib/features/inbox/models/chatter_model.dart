class ChatterModel {
  final String uid;
  final String name;
  final String username;
  final bool hasAvatar;
  final bool isParticipating;
  final int recentlyReadAt;
  final int showMsgFrom;

  ChatterModel({
    required this.uid,
    required this.name,
    required this.username,
    required this.hasAvatar,
    required this.recentlyReadAt,
    required this.showMsgFrom,
    required this.isParticipating,
  });

  ChatterModel.empty()
      : uid = '',
        name = '',
        username = '',
        hasAvatar = false,
        recentlyReadAt = 0,
        showMsgFrom = 0,
        isParticipating = false;

  ChatterModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        username = json['username'],
        hasAvatar = json['hasAvatar'],
        isParticipating = json['isParticipating'],
        recentlyReadAt = json['recentlyReadAt'],
        showMsgFrom = json['showMsgFrom'];

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'hasAvatar': hasAvatar,
      'isParticipating': isParticipating,
      'recentlyReadAt': recentlyReadAt,
      'showMsgFrom': showMsgFrom,
    };
  }

  ChatterModel copyWith({
    String? uid,
    String? name,
    String? username,
    bool? hasAvatar,
    bool? isParticipating,
    int? recentlyReadAt,
    int? showMsgFrom,
  }) {
    return ChatterModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      username: username ?? this.username,
      hasAvatar: hasAvatar ?? this.hasAvatar,
      isParticipating: isParticipating ?? this.isParticipating,
      recentlyReadAt: recentlyReadAt ?? this.recentlyReadAt,
      showMsgFrom: showMsgFrom ?? this.showMsgFrom,
    );
  }
}
