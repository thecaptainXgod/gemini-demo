import 'dart:math';

import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as provider;
import 'package:moonbase_widgets/moonbase_widgets.dart';
import 'package:tempo_x/creation/views/widgets/questions_list.dart';
import 'package:tempo_x/creation/views/widgets/review_quiz.dart';
import 'package:tempo_x/creation/views/widgets/select_group_and_title.dart';
import 'package:tempo_x/creation/views/widgets/snackbar.dart';

import '../../components/common_loading_button.dart';
import '../../components/icon_button.dart';
import '../../components/moonbase_success_screen.dart';
import '../bloc/quiz_creation_cubit.dart';
import '../models/group_model.dart';
import '../models/quiz_model.dart';


class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen(this.guideUnitNumber,
      {this.courseName, required this.isAiGenerated, super.key});

  final int guideUnitNumber;
  final String? courseName;
  final bool isAiGenerated;

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  int totalSteps = 3;
  int currentStep = 1;
  List<Widget> stepWidgets = [];
  List<String> stepTitles = [
    "Step 0: Welcome",
    "Step 1: Quiz Details",
    "Step 2: Set Questions",
    "Step 3: Review & Finish",
  ];
  IndexController indexController = IndexController();
  late TextEditingController quizTopic;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _buttonLoader =
      RoundedLoadingButtonController();

  @override
  void initState() {
    GroupModel currentGroup = GroupModel(groupName: "Group 1" , groupId: Random().nextInt(1000000).toString(), );
    if (!widget.isAiGenerated) {
      context.read<QuizCreationCubit>().updateQuiz(QuizModel(
            quizId: Random().nextInt(1000000).toString(),
            quizTitle: '',
            groupName: currentGroup.groupName!,
            courseName: widget.courseName ?? '',
            questions: [],
          ));
    }

    quizTopic = TextEditingController.fromValue(TextEditingValue(
        text: context.read<QuizCreationCubit>().state.quiz?.quizTitle ?? ""));
    stepWidgets = [
      SelectGroupAndTitle(
          titleController: quizTopic,
          courseName: widget.courseName,
          groupName: currentGroup.groupName),
      const QuestionsList(),
      const ReviewQuiz(),
    ];
    super.initState();
  }

  @override
  void dispose() {
    quizTopic.dispose();
    indexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(255, 255, 255, 1.0),
                      // Pure white (100% opacity)
                      Color.fromRGBO(255, 255, 255, 0.7),
                      // White with 70% opacity
                      Color.fromRGBO(255, 255, 255, 0.3),
                      // White with 30% opacity
                      Color.fromRGBO(255, 255, 255, 1.0),
                      // Pure white (100% opacity)
                    ],
                    stops: [0.0, 0.33, 0.67, 1.0], // Color stops
                    begin: Alignment.topRight, // Start from top-right
                    end: Alignment.bottomLeft, // End at bottom-left
                  ),
                  image: DecorationImage(
                      image: provider.Svg('assets/images/quiz_illustration.svg',
                          source: provider.SvgSource.asset),
                      alignment: Alignment.bottomRight,
                      opacity: 0.5,
                      colorFilter: ColorFilter.linearToSrgbGamma())),
              child: SafeArea(
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomIconButton(Icons.clear,
                          backgroundColor: Colors.white.withOpacity(.6),
                          onPressed: () {
                        Navigator.pop(context);
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Create a quiz",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            stepTitles[currentStep],
                            textScaleFactor: 1.2,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white.withOpacity(0.7),
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(
                                value: currentStep / totalSteps,
                                color: Colors.purple,
                                strokeWidth: 30,
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "$currentStep",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.purple),
                                    ),
                                    Text(
                                      "/$totalSteps",
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: formKey,
                    child: Expanded(
                      child: TransformerPageView(
                          loop: false,
                          index: currentStep - 1,
                          controller: indexController,
                          itemCount: stepWidgets.length,
                          onPageChanged: (int? currentPage) {
                            setState(() {
                              currentStep = (currentPage ?? 1) + 1;
                            });
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return stepWidgets[index];
                          }),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MLoadingButton(
                    loadingController: _buttonLoader,
                    text: currentStep == stepWidgets.length
                        ? "Finish"
                        : 'Continue',
                    width: MediaQuery.of(context).size.width,
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      if (currentStep == stepWidgets.length) {
                        //submit?
                        if (context
                                .read<QuizCreationCubit>()
                                .state
                                .quiz!
                                .groupName
                                .isEmpty ||
                            context
                                .read<QuizCreationCubit>()
                                .state
                                .quiz!
                                .courseName
                                .isEmpty ||
                            context
                                .read<QuizCreationCubit>()
                                .state
                                .quiz!
                                .quizTitle
                                .isEmpty) {
                          indexController.move(0);
                        } else if (context
                            .read<QuizCreationCubit>()
                            .state
                            .quiz!
                            .questions
                            .isEmpty) {
                          indexController.move(2);
                          displaySnackbar(context,
                              msg: "Please add at least one question");
                        } else {
                          _buttonLoader.start();
                          context.read<QuizCreationCubit>().addQuizToStream();
                          await Future.delayed(const Duration(seconds: 2));
                          _buttonLoader.success();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                  builder: (context) => MoonbaseSuccessScreen(
                                      message:
                                      "You have successfully created a quiz!",
                                      onProceed: (context) {
                                        Navigator.pop(context);
                                      }),
                            ));
                        }
                      } else {
                        // print("Current step: $currentStep");
                        switch (currentStep) {
                          case 1:
                            indexController.move(1);
                            break;
                          case 2:
                            if (context
                                .read<QuizCreationCubit>()
                                .state
                                .quiz!
                                .questions
                                .isEmpty) {
                              displaySnackbar(context,
                                  msg: "Please add at least one question");
                            } else {
                              indexController.move(3);
                            }

                            break;
                          default:
                        }
                      }
                    },
                  ),
                ]),
              )),
        ));
  }
}

class QuizListItem extends StatelessWidget {
  final QuizModel quiz;
  final VoidCallback onTap;

  const QuizListItem(this.quiz, this.onTap, {super.key});

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
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.question_answer),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.quizTitle,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.black),
                    ),
                    Text(
                      quiz.courseName,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      value: .3,
                    ),
                  ),
                  Text("30%")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
