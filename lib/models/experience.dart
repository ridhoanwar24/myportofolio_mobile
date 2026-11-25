import 'package:json_annotation/json_annotation.dart';

part 'experience.g.dart';

enum ExperienceCategory {
  @JsonValue('internship')
  internship,
  @JsonValue('research')
  research,
  @JsonValue('volunteer')
  volunteer,
  @JsonValue('part-time')
  partTime,
  @JsonValue('full-time')
  fullTime,
  @JsonValue('freelance')
  freelance,
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Experience {
  const Experience({
    this.id,
    required this.title,
    required this.description,
    this.category = ExperienceCategory.fullTime,
    this.thumbnail,
    this.startedAt,
    this.endedAt,
  });

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;
  final String title;
  final String description;
  @JsonKey(defaultValue: ExperienceCategory.fullTime)
  final ExperienceCategory category;
  final String? thumbnail; // null=True di Django
  @JsonKey(includeToJson: false)
  final DateTime? startedAt; // auto_now_add, diisi server
  final DateTime? endedAt; // null = masih berjalan

  bool get isOngoing => endedAt == null;

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}
