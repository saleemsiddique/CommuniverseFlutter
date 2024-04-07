import 'dart:convert';

import 'package:flutter/foundation.dart';

class Post {
  String id;
  String communityId;
  String authorId;
  String content;
  List<dynamic> photos;
  List<dynamic> videos;
  PostInteractions postInteractions;
  Quizz quizz;
  DateTime dateTime;
  bool isComment;

  Post({
    required this.id,
    required this.communityId,
    required this.authorId,
    required this.content,
    required this.photos,
    required this.videos,
    required this.postInteractions,
    required this.quizz,
    required this.dateTime,
    required this.isComment,
  });

  factory Post.empty() => Post(
        id: '',
        communityId: '',
        authorId: '',
        content: '',
        photos: [],
        videos: [],
        postInteractions: PostInteractions.empty(),
        quizz: Quizz.empty(),
        dateTime: DateTime.now(),
        isComment: false,
      );

  factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        communityId: json["community_id"],
        authorId: json["author_id"],
        content: json["content"],
        photos: List<dynamic>.from(json["photos"].map((x) => x)),
        videos: List<dynamic>.from(json["videos"].map((x) => x)),
        postInteractions: PostInteractions.fromJson(json["postInteractions"]),
        quizz: Quizz.fromJson(json["quizz"]),
        dateTime: DateTime.parse(json["dateTime"]),
        isComment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "community_id": communityId,
        "author_id": authorId,
        "content": content,
        "photos": List<dynamic>.from(photos.map((x) => x)),
        "videos": List<dynamic>.from(videos.map((x) => x)),
        "postInteractions": postInteractions.toJson(),
        "quizz": quizz.toJson(),
        "dateTime": dateTime.toIso8601String(),
        "comment": isComment,
      };
}

class PostInteractions {
  List<String> likeUsersId;
  List<String> repostUsersId;
  List<String> commentsId;

  PostInteractions({
    required this.likeUsersId,
    required this.repostUsersId,
    required this.commentsId,
  });

  PostInteractions.empty()
      : likeUsersId = [],
        repostUsersId = [],
        commentsId = [];

  factory PostInteractions.fromRawJson(String str) =>
      PostInteractions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostInteractions.fromJson(Map<String, dynamic> json) =>
      PostInteractions(
        likeUsersId:
            List<String>.from(json["like_users_id"].map((x) => x)),
        repostUsersId:
            List<String>.from(json["repost_users_id"].map((x) => x)),
        commentsId: List<String>.from(json["comments_id"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "like_users_id": List<dynamic>.from(likeUsersId.map((x) => x)),
        "repost_users_id": List<dynamic>.from(repostUsersId.map((x) => x)),
        "comments_id": List<dynamic>.from(commentsId.map((x) => x)),
      };
}


class Quizz {
  String id;
  String name;
  String description;
  List<Question> questions;

  Quizz({
    required this.id,
    required this.name,
    required this.description,
    required this.questions,
  });

  factory Quizz.empty() =>
      Quizz(id: '', name: '', description: '', questions: []);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Quizz &&
        other.id == id &&
        other.description == description &&
        listEquals(
            other.questions, questions); // Use listEquals to compare lists
  }

  @override
  int get hashCode => id.hashCode ^ description.hashCode ^ questions.hashCode;

  factory Quizz.fromRawJson(String str) => Quizz.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Quizz.fromJson(Map<String, dynamic> json) => Quizz(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };
}

class Question {
  String question;
  List<String> options;
  String correctAnswer;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.empty() =>
      Question(question: '', options: [], correctAnswer: '');

  factory Question.fromRawJson(String str) =>
      Question.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        question: json["question"],
        options: List<String>.from(json["options"].map((x) => x)),
        correctAnswer: json["correct_answer"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "options": List<dynamic>.from(options.map((x) => x)),
        "correct_answer": correctAnswer,
      };

  @override
  String toString() {
    return 'Question: $question\nOptions: $options\nCorrect Answer: $correctAnswer';
  }
}
