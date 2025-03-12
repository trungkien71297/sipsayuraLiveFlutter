class Voice {
  bool? floor;
  String? lastFloorTime;
  bool? joined;
  bool? listenOnly;
  String? userId;
  String? typename;

  Voice({
    this.floor,
    this.lastFloorTime,
    this.joined,
    this.listenOnly,
    this.userId,
    this.typename,
  });

  factory Voice.fromJson(Map<String, dynamic> json) => Voice(
        floor: json['floor'] as bool?,
        lastFloorTime: json['lastFloorTime'] as String?,
        joined: json['joined'] as bool?,
        listenOnly: json['listenOnly'] as bool?,
        userId: json['userId'] as String?,
        typename: json['__typename'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'floor': floor,
        'lastFloorTime': lastFloorTime,
        'joined': joined,
        'listenOnly': listenOnly,
        'userId': userId,
        '__typename': typename,
      };
}
