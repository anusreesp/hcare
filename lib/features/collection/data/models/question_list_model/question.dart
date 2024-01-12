import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  @JsonKey(name: 'QueID')
  String? queId;
  @JsonKey(name: 'QueName')
  String? queName;
  @JsonKey(name: 'AnswerType')
  String? answerType;
  @JsonKey(name: 'Answers')
  List<String> answers;

  Question(
      {this.queId, this.queName, this.answerType, this.answers = const []});

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}
