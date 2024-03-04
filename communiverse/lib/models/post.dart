import 'dart:convert';

class Post {
  String id;
  String communityId;
  String authorId;
  String? content;
  List<String>? photos;
  List<String>? videos;
  PostInteractions? postInteractions;
  String? repostUserId;
  Quizz? quizz;

  Post({
    required this.id,
    required this.communityId,
    required this.authorId,
  });

  factory Post.empty() => Post(
        id: '',
        communityId: '',
        authorId: '',
      );

  factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        communityId: json["community_id"],
        authorId: json["author_id"],

      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "community_id": communityId,
        "author_id": authorId,
        "content": content,
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

  factory PostInteractions.empty() => PostInteractions(likes: 0, reposts: 0, comments: []);

  factory PostInteractions.fromRawJson(String str) =>
      PostInteractions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostInteractions.fromJson(Map<String, dynamic> json) => PostInteractions(
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

  factory Quizz.fromRawJson(String str) => Quizz.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Quizz.fromJson(Map<String, dynamic> json) => Quizz(
        id: json["_id"],
        description: json["description"],
        questions:
            List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
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

  factory Question.empty() => Question(question: '', options: [], correctAnswer: '');

  factory Question.fromRawJson(String str) => Question.fromJson(json.decode(str));

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