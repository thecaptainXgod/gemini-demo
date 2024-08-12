import 'dart:convert';

enum QuizStatus {
  notStarted,
  inProgress,
  finished,
}

enum QuizType {
  manual,
  aiGenerated,
}

class QuizModel {
  String quizId;
  String quizTitle;
  String? quizDescription;
  String groupName;
  String courseName;
  QuizStatus status;
  QuizType quizType;
  List<QuestionModel> questions;
  List<int>? selectedUnits;

  QuizModel(
      {required this.quizId,
      required this.quizTitle,
      this.quizDescription,
      required this.groupName,
      required this.courseName,
      required this.questions,
      this.selectedUnits,
      this.status = QuizStatus.notStarted,
      this.quizType = QuizType.manual
      });

  factory QuizModel.fromMap(Map<String, dynamic> map) {
    return QuizModel(
      quizId: map['quizId'],
      quizTitle: map['quizTitle'],
      quizDescription: map['quizDescription'],
      groupName: map['groupName'],
      courseName: map['courseName'],
      selectedUnits: map['selectedUnits'],
      status: map['status'] != null ? QuizStatus.values.byName(map['status']) : QuizStatus.notStarted,
      quizType: map['quizType'] != null ? QuizType.values.byName(map['quizType']) : QuizType.manual,
      questions: List<QuestionModel>.from(map['questions']?.map((x) => QuestionModel.fromMap(x))),
    );
  }

  static List<QuizModel> fromMapArray(List<Map<String,dynamic>> maps){
    return maps.map((e) => QuizModel.fromMap(e)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'quizId': quizId,
      'quizTitle': quizTitle,
      'quizDescription': quizDescription,
      'groupName': groupName,
      'courseName': courseName,
      'status': status.name,
      'quizType': quizType.name,
      'selectedUnits': selectedUnits,
      'questions': questions.map((e) => e.toMap()).toList(),
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  static List<QuizModel> fromJsonArray(String quizzesJson) {
    List<dynamic> quizMaps = List<dynamic>.from(jsonDecode(quizzesJson));
    return quizMaps.map((e) => QuizModel.fromMap(e)).toList();
  }

  int calculateUnansweredQuestions() {
    int unansweredCount = 0;
    for (QuestionModel question in questions) {
      if (question.userSelectedChoiceIndex == -1) {
        unansweredCount++;
      }
    }
    return unansweredCount;
  }

  double calculateUserScore() {
    int totalQuestions = questions.length;
    int correctAnswers = 0;

    for (QuestionModel question in questions) {
      if (question.userSelectedChoiceIndex == question.correctChoiceIndex) {
        correctAnswers++;
      }
    }

    double score = (correctAnswers / totalQuestions) * 100.0;
    return score;
  }

  void resetChoices() {
    for (QuestionModel question in questions) {
      question.userSelectedChoiceIndex = -1;
    }
    status = QuizStatus.notStarted;
  }
}

class QuestionModel {
  String questionText;
  String prompt;
  List<ChoiceModel> choices;
  int correctChoiceIndex;
  int userSelectedChoiceIndex;
  String? questionId;
  String? questionImage;

  QuestionModel({
    required this.questionText,
    required this.choices,
    required this.correctChoiceIndex,
    this.questionId,
    this.prompt = "Select the appropriate answer",
    this.userSelectedChoiceIndex = -1,
    this.questionImage,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      questionText: map['questionText'],
      prompt: map['prompt'] ?? "",
      questionId: map['questionId']?.toString() ?? map["id"]?.toString(),
      correctChoiceIndex: map['correctChoiceIndex'] ??-1,
      questionImage: map['questionImage'] ?? map['image'],
      userSelectedChoiceIndex: map['userSelectedChoiceIndex'] == null ? -1 : int.parse(map['userSelectedChoiceIndex'].toString()),
      choices: [
        if (map['option1'] != null) ChoiceModel(choiceText: map["option1"]),
        if (map['option2'] != null) ChoiceModel(choiceText: map["option2"]),
        if (map['option3'] != null) ChoiceModel(choiceText: map["option3"]),
        if (map['option4'] != null) ChoiceModel(choiceText: map["option4"]),
      ],
    );
  }

  static List<QuestionModel> fromMapArray(List<dynamic> list){
    return list.map((e) => QuestionModel.fromMap(e)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'questionText': questionText,
      'prompt': prompt,
      'correctChoiceIndex': correctChoiceIndex,
      'questionId': questionId,
      'userSelectedChoiceIndex': userSelectedChoiceIndex,
      'questionImage': questionImage,
      'option1': choices.isNotEmpty ? choices[0].choiceText : null,
      'option2': choices.length > 1 ? choices[1].choiceText : null,
      'option3': choices.length > 2 ? choices[2].choiceText : null,
      'option4': choices.length > 3 ? choices[3].choiceText : null,
    };
  }
}

class ChoiceModel {
  String choiceText;

  ChoiceModel({required this.choiceText});
}

List<Map<String,dynamic>> sampleQuizzesJsonArray =[
  {
    "quizId": "1",
    "quizTitle": "Moon Base Company Culture Quiz",
    "quizDescription": "Test your knowledge about Moon Base's company culture and values.",
    "groupName": "Moon Base",
    "courseName": "Company Culture",
    "status": "notStarted",
    "quizType": "manual",
    "selectedUnits": null,
    "questions": [
      {
        "questionId": "1",
        "questionText": "What are the core values of Moon Base?",
        "prompt": "Select all that apply",
        "correctChoiceIndex": 3,
        "userSelectedChoiceIndex": -1,
        "option1": "Innovation",
        "option2": "Sustainability",
        "option3": "Compassion",
        "option4": "All of the above"
      },
      {
        "questionId": "2",
        "questionText": "Who is the CEO of Moon Base?",
        "prompt": "Select the correct answer",
        "correctChoiceIndex": 0,
        "userSelectedChoiceIndex": -1,
        "option1": "Anirudth Aditya",
        "option2": "John Doe",
        "option3": "Emily Smith",
        "option4": "Samantha Johnson"
      },
      {
        "questionId": "3",
        "questionText": "How did Moon Base start?",
        "prompt": "Select the correct answer",
        "correctChoiceIndex": 1,
        "userSelectedChoiceIndex": -1,
        "option1": "As a garage startup",
        "option2": "As a multinational corporation",
        "option3": "As a government project",
        "option4": "As a university research initiative"
      },
      {
        "questionId": "4",
        "questionText": "What distinguishes Moon Base from other companies?",
        "prompt": "Select all that apply",
        "correctChoiceIndex": 2,
        "userSelectedChoiceIndex": -1,
        "option1": "Revolutionary values",
        "option2": "Recognition by Microsoft",
        "option3": "Emphasis on innovation and compassion",
        "option4": "All of the above"
      }
    ]
  },
  {
    "quizId": "2",
    "quizTitle": "Moon Base Sustainability Quiz",
    "quizDescription": "Test your knowledge about Moon Base's sustainability initiatives.",
    "groupName": "Moon Base",
    "courseName": "Sustainability",
    "status": "notStarted",
    "quizType": "manual",
    "selectedUnits": null,
    "questions": [
      {
        "questionId": "5",
        "questionText": "What is one of Moon Base's primary focuses regarding sustainability?",
        "prompt": "Select the correct answer",
        "correctChoiceIndex": 2,
        "userSelectedChoiceIndex": -1,
        "option1": "Deforestation",
        "option2": "Pollution control",
        "option3": "Renewable energy",
        "option4": "Oil drilling"
      },
      {
        "questionId": "6",
        "questionText": "Which company recognized Moon Base for its achievements?",
        "prompt": "Select the correct answer",
        "correctChoiceIndex": 1,
        "userSelectedChoiceIndex": -1,
        "option1": "Google",
        "option2": "Microsoft",
        "option3": "Amazon",
        "option4": "Facebook"
      },
      {
        "questionId": "7",
        "questionText": "What kind of impact does Moon Base aim to have on the world?",
        "prompt": "Select all that apply",
        "correctChoiceIndex": 3,
        "userSelectedChoiceIndex": -1,
        "option1": "Positive",
        "option2": "Neutral",
        "option3": "Negative",
        "option4": "Transformative"
      },
      {
        "questionId": "8",
        "questionText": "How does Moon Base support personal growth and development?",
        "prompt": "Select the correct answer",
        "correctChoiceIndex": 0,
        "userSelectedChoiceIndex": -1,
        "option1": "By encouraging collaboration and fresh ideas",
        "option2": "By limiting employee freedom",
        "option3": "By enforcing strict rules and regulations",
        "option4": "By discouraging innovation"
      }
    ]
  }
];
