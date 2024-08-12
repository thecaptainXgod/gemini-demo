import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/quiz_creation_cubit.dart';
import '../../models/quiz_model.dart';
import '../create_question_screen.dart';

class QuestionsList extends StatelessWidget {
  const QuestionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text("Add Questions"),
            RawMaterialButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreateQuestionScreen(
                        QuestionModel(
                            choices: [],
                            correctChoiceIndex: -1,
                            questionText: '',
                            userSelectedChoiceIndex: -1),
                        false)));
              },
              elevation: 0,
              fillColor: Colors.purple,
              shape: const StadiumBorder(),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text(
                      "New",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.add, color: Colors.white)
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<QuizCreationCubit, QuizCreationState>(
            builder: (context, state) {
          return Expanded(
              child: ListView.builder(
                  itemCount: state.quiz!.questions.length,
                  itemBuilder: (context, index) {
                    return QuestionListItem(
                      state.quiz!.questions[index],
                      () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CreateQuestionScreen(
                                state.quiz!.questions[index], true)));
                      },
                      index: index,
                    );
                  }));
        })
      ],
    );
  }
}

class QuestionListItem extends StatelessWidget {
  final VoidCallback onTap;
  final QuestionModel question;
  final int index;
  final bool showDelete;

  const QuestionListItem(this.question, this.onTap,
      {this.index = 0, this.showDelete = true, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white.withOpacity(0.5),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.questionText,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.black),
                    ),
                    Text(
                      "${question.choices.length} choices",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              if (showDelete)
                IconButton(
                    onPressed: () {
                      context
                          .read<QuizCreationCubit>()
                          .state
                          .quiz!
                          .questions
                          .removeAt(index);
                      context.read<QuizCreationCubit>().updateQuiz(
                          context.read<QuizCreationCubit>().state.quiz);
                    },
                    icon: const Icon(Icons.delete_forever))
            ],
          ),
        ),
      ),
    );
  }
}
