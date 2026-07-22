// ignore_for_file: prefer_interpolation_to_compose_strings

class ChannelModel {
  final int id;
  final int schoolId;
  final String name;

  final SchoolChannelModel school;
  final GradeChannelModel? grade;
  final ClassChannelModel? classroom;

  ChannelModel({
    required this.id,
    required this.name,
    required this.schoolId,
    required this.school,
    required this.grade,
    required this.classroom,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'],
      name: (json['classes'] != null)
          ? json['grades']['name'] + ' - ' + json['classes']['nickname']
          : (json['grades'] != null)
          ? json['grades']['name'] + ' - ' + 'Grade Announcement Channel'
          : (json['school_id'] != null)
          ? 'General Announcement Channel'
          : 'Unknown Channel',
      schoolId: json['school_id'],
      school: SchoolChannelModel.fromJson(json['schools']),
      grade: json['grades'] != null
          ? GradeChannelModel.fromJson(json['grades'])
          : null,
      classroom: json['classes'] != null
          ? ClassChannelModel.fromJson(json['classes'])
          : null,
    );
  }
}

class SchoolChannelModel {
  final int id;
  final String name;

  SchoolChannelModel({required this.id, required this.name});

  factory SchoolChannelModel.fromJson(Map<String, dynamic> json) {
    return SchoolChannelModel(id: json['id'], name: json['name']);
  }
}

class GradeChannelModel {
  final int id;
  final String name;

  GradeChannelModel({required this.id, required this.name});

  factory GradeChannelModel.fromJson(Map<String, dynamic> json) {
    return GradeChannelModel(id: json['id'], name: json['name']);
  }
}

class ClassChannelModel {
  final int id;
  final String name;
  final String nickname;

  ClassChannelModel({
    required this.id,
    required this.name,
    required this.nickname,
  });

  factory ClassChannelModel.fromJson(Map<String, dynamic> json) {
    return ClassChannelModel(
      id: json['id'],
      name: json['name'],
      nickname: json['nickname'],
    );
  }
}
