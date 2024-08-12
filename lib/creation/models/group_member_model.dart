import 'dart:convert';

enum MemberType{
  owner,
  admin,
  member
}

class GroupMember {
  final String organizationId;
  final String groupId;
  final String firstName;
  final String lastName;
  final String email;
  final String profileImageUrl;
  final String uid;
  final MemberType memberType;

  static const String defaultProfileImageUrl = "https://www.tempospace.co/wp-content/uploads/2023/05/Asset-4.png";

  GroupMember({
    required this.organizationId,
    required this.groupId,
    required this.uid,
    required this.memberType,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImageUrl
  });

  Map<String, dynamic> toMap() {
    return {
      'organizationId': organizationId,
      'groupId': groupId,
      'id': uid,
      'memberType': memberType.name.toUpperCase(),
      'email': email,
      'icon': profileImageUrl,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  factory GroupMember.fromMap(Map<String, dynamic> map) {
    return GroupMember(
      organizationId: (map['organizationId'] ?? '').toString(),
      groupId: (map['groupId'] ?? '').toString(),
      uid: (map['id'] ?? '').toString(),
      memberType: MemberType.values.byName((map['userType']?.toString().toLowerCase()) ?? MemberType.member.name),
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['icon'] ?? defaultProfileImageUrl
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupMember.fromJson(String source) =>
      GroupMember.fromMap(json.decode(source));

  static List<GroupMember> fromMapArray(List<dynamic> mapArray){
    return List.generate(mapArray.length, (index) => GroupMember.fromMap(mapArray[index]));
  }

}
