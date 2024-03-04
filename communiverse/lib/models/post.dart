import 'dart:convert';

import 'package:flutter/foundation.dart';

class Post {
  String id;
  String communityId;
  String authorId;
  String content;
  List<String> photos;
  List<String> videos;
  PostInteractions postInteractions;
  String repostUserId;
  Quizz quizz;
  DateTime dateTime;

  Post({
    required this.id,
    required this.communityId,
    required this.authorId,
    required this.content,
    required this.photos,
    required this.videos,
    required this.postInteractions,
    required this.repostUserId,
    required this.quizz,
    required this.dateTime,
  });

  factory Post.empty() => Post(
      id: '',
      communityId: '',
      authorId: '',
      content: '',
      photos: [],
      videos: [],
      postInteractions: PostInteractions.empty(),
      repostUserId: '',
      quizz: Quizz.empty(),
      dateTime: DateTime.now());

   factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        communityId: json["community_id"],
        authorId: json["author_id"],
        content: json["content"],
        photos: List<String>.from(json["photos"].map((x) => x)),
        videos: List<String>.from(json["videos"].map((x) => x)),
        postInteractions: PostInteractions.fromJson(json["postInteractions"]),
        repostUserId: json["repost_user_id"],
        quizz: Quizz.fromJson(json["quizz"]),
        dateTime: DateTime.parse(json["dateTime"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "community_id": communityId,
        "author_id": authorId,
        "content": content,
        "photos": List<dynamic>.from(photos.map((x) => x)),
        "videos": List<dynamic>.from(videos.map((x) => x)),
        "postInteractions": postInteractions.toJson(),
        "repost_user_id": repostUserId,
        "quizz": quizz.toJson(),
        "dateTime": dateTime.toIso8601String(),
    };
}
class PostInteractions {
  int likes;
  int reposts;
  List<dynamic> comments;

  PostInteractions({
    required this.likes,
    required this.reposts,
    required this.comments,
  });

  factory PostInteractions.empty() =>
      PostInteractions(likes: 0, reposts: 0, comments: []);

  factory PostInteractions.fromRawJson(String str) =>
      PostInteractions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostInteractions.fromJson(Map<String, dynamic> json) =>
      PostInteractions(
        likes: json["likes"],
        reposts: json["reposts"],
        comments: List<dynamic>.from(json["comments"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "likes": likes,
        "reposts": reposts,
        "comments": List<dynamic>.from(comments.map((x) => x)),
      };
}

class Quizz {
  String id;
  String description;
  List<Question> questions;

  Quizz({
    required this.id,
    required this.description,
    required this.questions,
  });

  factory Quizz.empty() => Quizz(id: '', description: '', questions: []);

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
        description: json["description"],
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
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
}