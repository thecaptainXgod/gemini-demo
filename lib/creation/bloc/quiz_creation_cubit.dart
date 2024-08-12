import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';


import '../models/quiz_model.dart';

class QuizCreationCubit extends Cubit<QuizCreationState> {
  StreamController<String>? quizCreationStream;


  QuizCreationCubit(super.initialState);

  void updateQuiz(QuizModel? quiz) {
    emit(state.copyWith(quiz: quiz));
  }

  void addQuizToStream() {
    if (state.quiz != null) {
      quizCreationStream?.add(state.quiz!.toJson());
    }
  }

  QuizModel get quiz => state.quiz!;

  initQuizCreationStream() {
    closeQuizCreationStream();
    quizCreationStream = StreamController<String>();
    return quizCreationStream;
  }

  closeQuizCreationStream() {
    if (quizCreationStream != null && !(quizCreationStream!.isClosed)) {
      quizCreationStream?.close();
    }
  }

}

class QuizCreationState {
  QuizModel? quiz;

  QuizCreationState({this.quiz});

  QuizCreationState copyWith({QuizModel? quiz}) {
    return QuizCreationState(
      quiz: quiz ?? this.quiz,
    );
  }
}
