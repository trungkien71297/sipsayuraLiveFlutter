class User {
  String? name;
  String? userId;
  String? nameSortable;
  bool? pinned;
  bool? away;
  bool? disconnected;
  String? role;
  String? avatar;
  String? color;
  bool? presenter;
  String? clientType;
  bool? raiseHand;
  bool? isModerator;
  dynamic reactionEmoji;
  String? typename;

  User({
    this.name,
    this.userId,
    this.nameSortable,
    this.pinned,
    this.away,
    this.disconnected,
    this.role,
    this.avatar,
    this.color,
    this.presenter,
    this.clientType,
    this.raiseHand,
    this.isModerator,
    this.reactionEmoji,
    this.typename,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'] as String?,
        userId: json['userId'] as String?,
        nameSortable: json['nameSortable'] as String?,
        pinned: json['pinned'] as bool?,
        away: json['away'] as bool?,
        disconnected: json['disconnected'] as bool?,
        role: json['role'] as String?,
        avatar: json['avatar'] as String?,
        color: json['color'] as String?,
        presenter: json['presenter'] as bool?,
        clientType: json['clientType'] as String?,
        raiseHand: json['raiseHand'] as bool?,
        isModerator: json['isModerator'] as bool?,
        reactionEmoji: json['reactionEmoji'] as dynamic,
        typename: json['__typename'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'userId': userId,
        'nameSortable': nameSortable,
        'pinned': pinned,
        'away': away,
        'disconnected': disconnected,
        'role': role,
        'avatar': avatar,
        'color': color,
        'presenter': presenter,
        'clientType': clientType,
        'raiseHand': raiseHand,
        'isModerator': isModerator,
        'reactionEmoji': reactionEmoji,
        '__typename': typename,
      };
}
