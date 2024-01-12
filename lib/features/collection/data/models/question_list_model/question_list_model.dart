import 'package:json_annotation/json_annotation.dart';

import 'question.dart';

part 'question_list_model.g.dart';

@JsonSerializable()
class QuestionListModel {
  @JsonKey(name: 'Ques')
  final List<Question> questions;

  QuestionListModel({
    this.questions = const [],
  });

  factory QuestionListModel.fromJson(Map<String, dynamic> json) {
    return _$QuestionListModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$QuestionListModelToJson(this);
}
