import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as provider;
import 'package:moonbase_explore/utils/enums.dart';
import 'package:moonbase_explore/widgets/common_edit_text_field.dart';
import 'package:tempo_x/creation/views/widgets/snackbar.dart';

import '../../components/common_text.dart';
import '../../components/icon_button.dart';
import '../../utils/moonbase_text_button.dart';
import '../bloc/quiz_creation_cubit.dart';
import '../models/quiz_model.dart';


class CreateQuestionScreen extends StatefulWidget {
  final QuestionModel questionModel;
  final int questionIndex;
  final bool isEdited;
  static const List<String> optionLabels = ["A", "B", "C", "D"];

  const CreateQuestionScreen(this.questionModel, this.isEdited, {this.questionIndex = -1, super.key});

  @override
  State<CreateQuestionScreen> createState() => _CreateQuestionScreenState();
}

class _CreateQuestionScreenState extends State<CreateQuestionScreen> {
  late TextEditingController questionController, promptController, choiceController;
  static const int maxChoices = 4;

  @override
  void initState() {
    questionController = TextEditingController.fromValue(TextEditingValue(text: widget.questionModel.questionText));
    promptController = TextEditingController.fromValue(TextEditingValue(text: widget.questionModel.prompt));
    choiceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    questionController.dispose();
    promptController.dispose();
    choiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator QuizentryWidget - GROUP
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
                      Color.fromRGBO(255, 255, 255, 1.0), // Pure white (100% opacity)
                      Color.fromRGBO(255, 255, 255, 0.7), // White with 70% opacity
                      Color.fromRGBO(255, 255, 255, 0.3), // White with 30% opacity
                      Color.fromRGBO(255, 255, 255, 1.0), // Pure white (100% opacity)
                    ],
                    stops: [0.0, 0.33, 0.67, 1.0], // Color stops
                    begin: Alignment.topRight, // Start from top-right
                    end: Alignment.bottomLeft, // End at bottom-left
                  ),
                  image: DecorationImage(
                      image: provider.Svg('assets/images/quiz_illustration.svg', source: provider.SvgSource.asset),
                      alignment: Alignment.bottomRight,
                      opacity: 0.5,
                      colorFilter: ColorFilter.linearToSrgbGamma())),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomIconButton(Icons.clear, backgroundColor: Colors.white.withOpacity(.6), onPressed: () {
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
                              "Create a question",
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Set Question & Choices",
                              textScaleFactor: 1.2,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                        //
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TTextField(
                      choice: ChoiceEnum.optionalText,
                      controller: questionController,
                      label: "Enter Question",
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TTextField(
                      choice: ChoiceEnum.optionalText,
                      controller: promptController,
                      label: "Enter Prompt",
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TTextField(
                              choice: ChoiceEnum.optionalText,
                              controller: choiceController,
                              label: "Add Choice",
                              isEnabled: widget.questionModel.choices.length < maxChoices),
                        ),
                        IconButton(
                            onPressed: () {
                              if (choiceController.text.isEmpty) return;
                              if (widget.questionModel.choices.length >= maxChoices) {
                                displaySnackbar(context, msg: "Sorry, maximum number of choices is 4");
                                return;
                              }
                              setState(() {
                                widget.questionModel.choices.add(ChoiceModel(choiceText: choiceController.text.trim()));
                              });
                              choiceController.text = "";
                            },
                            icon: const Icon(Icons.add)),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const MText("Select the correct option below", variant: TypographyVariant.subtitleSmall),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      constraints: const BoxConstraints(minHeight: 300),
                      width: MediaQuery.of(context).size.width - 30,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                          widget.questionModel.choices.length,
                          (index) => _buildOption(context,
                              optionLabel: CreateQuestionScreen.optionLabels[index],
                              choiceText: widget.questionModel.choices[index].choiceText,
                              selected: widget.questionModel.correctChoiceIndex == index,
                              onChoiceSelected: () => setCorrectChoice(index),
                              onDelete: () {
                                setState(() {
                                  widget.questionModel.choices.removeAt(index);
                                });
                              }),
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      margin: const EdgeInsets.only(
                        left: 10,
                        top: 40,
                        right: 10,
                        bottom: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: MoonbaseTextButton(
                        text: widget.isEdited ? 'Update' : 'Continue',
                        width: MediaQuery.of(context).size.width,
                        onPressed: () {
                          if (widget.questionModel.choices.length < 2) {
                            displaySnackbar(context, msg: "Please add at least two options");
                            return;
                          }

                          if (widget.questionModel.correctChoiceIndex < 0 ||
                              widget.questionModel.correctChoiceIndex >= widget.questionModel.choices.length) {
                            displaySnackbar(context, msg: "Please select a correct option");
                            return;
                          }

                          widget.questionModel.questionText = questionController.text;
                          widget.questionModel.prompt = promptController.text;
                          if (widget.isEdited) {
                            context.read<QuizCreationCubit>().state.quiz!.questions.remove(widget.questionModel);
                            context.read<QuizCreationCubit>().state.quiz!.questions.add(widget.questionModel);
                          } else if (widget.questionIndex == -1) {
                            context.read<QuizCreationCubit>().state.quiz!.questions.add(widget.questionModel);
                            context.read<QuizCreationCubit>().updateQuiz(context.read<QuizCreationCubit>().state.quiz);
                          } else {
                            context.read<QuizCreationCubit>().state.quiz!.questions[widget.questionIndex] =
                                widget.questionModel;
                            context.read<QuizCreationCubit>().updateQuiz(context.read<QuizCreationCubit>().state.quiz);
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ]),
                ),
              )),
        ));
  }

  void setCorrectChoice(int choiceIndex) {
    setState(() {
      widget.questionModel.correctChoiceIndex = choiceIndex;
    });
  }

  Widget _buildOption(BuildContext context,
      {required String optionLabel,
      required String choiceText,
      required Function() onChoiceSelected,
      required Function() onDelete,
      bool selected = false}) {
    return GestureDetector(
      onTap: () {
        onChoiceSelected();
      },
      child: Card(
        color: (selected ? Colors.purple : Colors.white).withOpacity(0.5),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "$optionLabel.",
                  textScaleFactor: 1.2,
                  maxLines: 3,
                  style: TextStyle(color: selected ? Colors.white : Colors.black),
                ),
              ),
              Expanded(
                  child: SizedBox(
                      height: 60,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            choiceText,
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: selected ? Colors.grey[200] : Colors.black),
                          )))),
              IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_forever))
            ],
          ),
        ),
      ),
    );
  }
}
