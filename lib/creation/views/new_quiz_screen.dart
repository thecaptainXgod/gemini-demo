import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moonbase_explore/app_constants/custom_snackbars.dart';

import 'package:moonbase_theme/colors/colors.dart';
import 'package:moonbase_theme/colors/dark_theme_palette.dart';
import 'package:moonbase_widgets/moonbase_widgets.dart';
import 'package:tempo_x/creation/views/show_prompt.dart';
import 'package:tempo_x/creation/views/widgets/snackbar.dart';

import '../../components/common_loader.dart';
import '../../components/question_image_button.dart';
import '../../models/guide_ai.dart';
import '../models/quiz_model.dart';
import 'add_question_screen.dart';

class NewQuizScreen extends StatefulWidget {
  final QuizModel? quizModel;
  final Function()? onDeleteQuiz;
  final bool createQuiz;
  final Guide? guide;

  const NewQuizScreen({this.quizModel,
    this.createQuiz = false,
    this.onDeleteQuiz,
    this.guide,
    super.key});

  @override
  State<NewQuizScreen> createState() => _NewQuizScreenState();
}

class _NewQuizScreenState extends State<NewQuizScreen> {
  List<QuestionModel> questions = [];
  TextEditingController quizNameController = TextEditingController();
  TextEditingController quizDescriptionController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool creatingQuiz = false;

  finishEditing() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (questions.isEmpty) {
      displaySnackbar(context, msg: "Please add least one question");
      return;
    }
    final quizModel = QuizModel(
        quizId: widget.quizModel?.quizId ?? "",
        quizTitle: quizNameController.text,
        groupName: "",
        courseName: "",
        questions: questions,
        quizDescription: quizDescriptionController.text);
    if (widget.createQuiz) {
      // Navigator.pop(context, quizModel);

      // call APi

    } else {
      Navigator.pop(context, quizModel);
    }
  }

  void discardQuiz() {
    if (widget.onDeleteQuiz != null) {
      Navigator.pop(context);
    } else {
      showPrompt("Discard Quiz?",
          "You are about to discard this quiz and all data under this will be lost, proceed?",
          onProceed: () => Navigator.pop(context), context: context);
    }
  }

  @override
  void initState() {
    if (widget.quizModel != null) {
      questions = widget.quizModel?.questions ?? [];
      quizNameController.text = widget.quizModel?.quizTitle ?? "";
      quizDescriptionController.text = widget.quizModel?.quizDescription ?? "";
    }
    super.initState();
  }

  void addQuestion() async {
    final questionModel = await Navigator.of(context)
        .push(
        MaterialPageRoute(builder: (context) => AddQuestionScreen(questions.length + 1)));

    if (questionModel != null) {
      setState(() {
        questions.add(questionModel as QuestionModel);
      });
      if ((questionModel as QuestionModel).questionId == "+1") {
        // add another question
        addQuestion();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        discardQuiz();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "New Quiz",
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          floatingActionButton: MoonbaseFab(
            onPressed: creatingQuiz ? () {} : finishEditing,
            child: creatingQuiz
                ? const MLoader(
              color: DarkThemePalette.secondaryColor,
            )
                : SvgPicture.asset(
              IconsAsset.blackLongArrowRight,
              width: 20,
              height: 20,
              package: 'moonbase_widgets',
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    MoonbaseTextField(
                      labelText: "Quiz Name",
                      controller: quizNameController,
                      validator: (s) =>
                      s == null || s.isEmpty ? "Field is required" : null,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MoonbaseTextField(
                      labelText: "Description (optional) ",
                      controller: quizDescriptionController,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: MoonbaseButton(
                              text: "Question",
                              iconPrefix: Icons.add,
                              onPressed: addQuestion),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                            child: MoonbaseButton(
                              text: "Delete",
                              color: Colors.red,
                              textColor: Colors.white,
                              onPressed: () {
                                if (widget.onDeleteQuiz != null) {
                                  showPrompt("Delete Quiz?",
                                      "Are you sure you want to delete this quiz?",
                                      onProceed: () {
                                        widget.onDeleteQuiz!();
                                        Navigator.pop(context);
                                      }, context: context);
                                } else {
                                  discardQuiz();
                                }
                              },
                            )),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                          questions.length,
                              (index) =>
                              Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                                "${index +
                                                    1}. ${questions[index]
                                                    .questionText}"),
                                          ),
                                          PopupMenuButton<int>(
                                            itemBuilder: (context) =>
                                            [
                                              // popupmenu item 1
                                              PopupMenuItem(
                                                  value: 1,
                                                  onTap: () async {
                                                    final updated = await Navigator
                                                        .of(context)
                                                        .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddQuestionScreen(
                                                                  index + 1,
                                                                  existingQuestion:
                                                                  questions[index],
                                                                  onDeleteQuestion: () {
                                                                    setState(() {
                                                                      questions
                                                                          .removeAt(
                                                                          index);
                                                                    });
                                                                  }),
                                                        ));
                                                        if (updated != null)
                                                    {
                                                      setState(() {
                                                        questions[index] =
                                                            updated;
                                                      });
                                                      if ((updated
                                                      as QuestionModel)
                                                          .questionId ==
                                                          "+1") {
                                                        addQuestion();
                                                      }
                                                    }
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                    EdgeInsets.all(8.0),
                                                    child: Text("Edit"),
                                                  )),
                                              PopupMenuItem(
                                                  value: 2,
                                                  onTap: () {
                                                    setState(() {
                                                      questions.removeAt(index);
                                                    });
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                    EdgeInsets.all(8.0),
                                                    child: Text("Delete"),
                                                  )),
                                            ],
                                            offset: const Offset(100, 0),
                                            color: Colors.grey,
                                            elevation: 2,
                                            child: const Icon(
                                              Icons.more_vert,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      QuestionImageButton(
                                          questions[index].questionImage),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: List.generate(
                                                questions[index].choices.length,
                                                    (index2) =>
                                                    Row(
                                                      children: [
                                                        _buildRadioButton(
                                                            index2 ==
                                                                questions[index]
                                                                    .correctChoiceIndex),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          "${AddQuestionScreen
                                                              .choiceLabels[index2]}) ${questions[index]
                                                              .choices[index2]
                                                              .choiceText}",
                                                          style: Theme
                                                              .of(
                                                              context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                              color: index2 ==
                                                                  questions[index]
                                                                      .correctChoiceIndex
                                                                  ? Theme
                                                                  .of(
                                                                  context)
                                                                  .primaryColor
                                                                  : null),
                                                        ),
                                                      ],
                                                    ))),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _buildRadioButton(bool activated) {
    return Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
            width: activated ? 3 : 1,
            color: activated ? Theme
                .of(context)
                .primaryColor : Colors.white,
            style: BorderStyle.solid,
          ),
        ));
  }
}
