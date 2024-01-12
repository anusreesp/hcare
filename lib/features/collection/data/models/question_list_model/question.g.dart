// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      queId: json['QueID'] as String?,
      queName: json['QueName'] as String?,
      answerType: json['AnswerType'] as String?,
      answers: (json['Answers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'QueID': instance.queId,
      'QueName': instance.queName,
      'AnswerType': instance.answerType,
      'Answers': instance.answers,
    };
