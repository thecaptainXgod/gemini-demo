import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempo_x/creation/views/widgets/questions_list.dart';

import '../../../components/common_text.dart';
import '../../bloc/quiz_creation_cubit.dart';

class ReviewQuiz extends StatelessWidget {
  const ReviewQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizCreationCubit, QuizCreationState>(builder: (context, state) {
      return Column(
        children: [
          Card(
            color: Colors.white.withOpacity(0.5),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.people),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selected Group",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                        ),
                        Text(
                          state.quiz!.groupName,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.white.withOpacity(0.5),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.explore),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selected Course",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                        ),
                        Text(
                          state.quiz!.courseName,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.white.withOpacity(0.5),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.title),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Quiz Title",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                        ),
                        Text(
                          state.quiz!.quizTitle,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Divider(),
              MText("Questions (${state.quiz!.questions.length})", variant: TypographyVariant.subtitleSmall),
              const Divider()
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: state.quiz!.questions.length,
                itemBuilder: (context, index) {
                  return QuestionListItem(state.quiz!.questions[index], () {}, index: index, showDelete: false);
                }),
          ),
        ],
      );
    });
  }
}
