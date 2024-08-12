import 'dart:convert';

import 'group_member_model.dart';





class GroupModel {
  String? orgId;
  String? groupId = '';
  String? groupName;
  final String? groupImageUrl;
  final String? localImageUrl;
  final String? groupDescription;
  final int? userCount;
  final List<String>? guides;

  final MemberType memberType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  static const String defaultImageUrl =
      "https://moonbase-icons.s3.amazonaws.com/icons/undefined.png";

  GroupModel({
    this.orgId,
    this.groupId,
    this.groupName,
    this.groupImageUrl,
    this.localImageUrl,
    this.groupDescription,
    this.guides,
    this.memberType = MemberType.member,
    this.userCount = 1,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'organizationId': orgId,
      'id': groupId,
      'groupName': groupName,
      'icon': groupImageUrl,
      'localImageUrl': localImageUrl,
      'groupDescription': groupDescription,
      'guides': guides,
      'userType': memberType.name,
      'userCount': userCount,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static List<GroupModel> fromMapArray(List<dynamic> mapArray) {
    return List.generate(
        mapArray.length, (index) => GroupModel.fromMap(mapArray[index]));
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      orgId: (map['organizationId'] ?? map['orgId'] ?? '').toString(),
      groupId: (map['groupid'] ?? map['id'] ?? map['groupId'] ?? '').toString(),
      groupName: map['groupName'] ?? '',
      groupImageUrl: map['icon'],
      localImageUrl: map['localImageUrl'],
      memberType: (map['userType'] ?? map['usertype']) != null
          ? MemberType.values.byName(
              (map['userType'] ?? map['usertype']).toString().toLowerCase())
          : MemberType.member,
      groupDescription: map['groupDescription'] ?? map['description'],
      userCount: int.tryParse(
              (map['userCount'] ?? map['usercount'] ?? "1").toString()) ??
          1,
      createdAt:
          map['createdAt'] == null ? null : DateTime.parse(map["createdAt"]),
      updatedAt:
          map['updatedAt'] == null ? null : DateTime.parse(map["updatedAt"]),
    );
  }

  GroupModel copyWith({
    String? orgId,
    String? groupId,
    String? groupName,
    String? groupImageUrl,
    String? localImageUrl,
    String? groupDescription,
    int? userCount,
    MemberType? memberType,
    List<String>? guides,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GroupModel(
      orgId: orgId ?? this.orgId,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      groupImageUrl: groupImageUrl ?? this.groupImageUrl,
      localImageUrl: localImageUrl ?? this.localImageUrl,
      groupDescription: groupDescription ?? this.groupDescription,
      guides: guides ?? this.guides,
      memberType: memberType ?? this.memberType,
      userCount: userCount ?? this.userCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupModel.fromJson(String source) =>
      GroupModel.fromMap(json.decode(source));
}
