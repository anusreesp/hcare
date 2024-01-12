// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionListModel _$QuestionListModelFromJson(Map<String, dynamic> json) =>
    QuestionListModel(
      questions: (json['Ques'] as List<dynamic>?)
              ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$QuestionListModelToJson(QuestionListModel instance) =>
    <String, dynamic>{
      'Ques': instance.questions,
    };
