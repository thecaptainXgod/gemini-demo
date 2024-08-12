import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:moonbase_widgets/moonbase_widgets.dart';
import 'package:tempo_x/creation/views/show_prompt.dart';
import 'package:tempo_x/creation/views/widgets/snackbar.dart';

import '../../components/common_cards.dart';
import '../models/quiz_model.dart';

class AddQuestionScreen extends StatefulWidget {
  static const choiceLabels = ["a", "b", "c", "d", "e"];

  final QuestionModel? existingQuestion;
  final int questionNumber;
  final Function()? onDeleteQuestion;

  const AddQuestionScreen(this.questionNumber,
      {super.key, this.existingQuestion, this.onDeleteQuestion});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  String? questionImage;
  List<String> choices = [
    "",
    "",
  ];
  int? correctChoice;
  final TextEditingController questionController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  _selectChoice(int? choice) {
    setState(() {
      correctChoice = choice;
    });
  }

  void discardQuestion() {
    showPrompt(
        "Discard Question", "Are you sure you want to discard this question?",
        context: context, onProceed: () => Navigator.pop(context));
  }

  @override
  void initState() {
    if (widget.existingQuestion != null) {
      questionImage = widget.existingQuestion?.questionImage;
      choices =
          widget.existingQuestion?.choices.map((e) => e.choiceText).toList() ??
              ["", ""];
      correctChoice = widget.existingQuestion?.correctChoiceIndex;
      questionController.text = widget.existingQuestion?.questionText ?? "";
    }
    super.initState();
  }

  @override
  void dispose() {
    questionController.dispose();
    super.dispose();
  }

  finishEdit({bool addAnother = false}) {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (correctChoice == null) {
      displaySnackbar(context, msg: "Select the correct option");
      return;
    }

    Navigator.pop(
        context,
        QuestionModel(
            questionId: addAnother ? "+1" : null,
            questionText: questionController.text,
            choices: List.generate(choices.length,
                (index) => ChoiceModel(choiceText: choices[index])),
            correctChoiceIndex: correctChoice!,
            questionImage: questionImage));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.onDeleteQuestion == null ? false : true,
      onPopInvoked: (didPop) {
        if (didPop) return;
        discardQuestion();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Add Question"),
          ),
          resizeToAvoidBottomInset: true,
          floatingActionButton: MoonbaseFab(
            onPressed: finishEdit,
            child: SvgPicture.asset(
              IconsAsset.blackLongArrowRight,
              width: 20,
              height: 20,
              package: 'moonbase_widgets',
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    RawMaterialButton(
                      onPressed: () {
                        pickImageFromGalleryAndCompress(context).then((value) {
                          if (value == null) return;
                          setState(() {
                            questionImage = value.path;
                          });
                        }).catchError((err) {
                          displaySnackbar(context,
                              msg:
                                  "Sorry! we currently don't support this format. Please use jpeg/jpg or png");
                        });
                      },
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      fillColor: Theme.of(context).primaryColor,
                      child: questionImage == null
                          ? const SizedBox(
                              height: 250,
                              width: 200,
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : CardFileImage(
                              imageString: questionImage!,
                              size: const Size(200, 250),
                              radius: 20,
                            ),
                    ),
                    Row(
                      children: [
                        Text(
                          "${widget.questionNumber}.",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(fontSize: 30),
                        ),
                        const Expanded(
                            child:
                                Center(child: Text("Add an image (optional)"))),
                      ],
                    ),
                    MoonbaseTextField(
                      labelText: "Question",
                      controller: questionController,
                      validator: (s) {
                        if (s == null || s.isEmpty) return "Add some text here";
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      children: [
                        Text("Select the correct option"),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 7,
                          );
                        },
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: choices.length,
                        itemBuilder: (context, index) {
                          return MoonbaseTextField(
                            initialValue: choices[index],
                            prefixIcon: SizedBox(
                              width: 60,
                              child: InkWell(
                                  onTap: () {
                                    _selectChoice(index);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            _buildRadioButton(
                                                index == correctChoice),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              "Correct",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      fontSize: 7.5,
                                                      color: Colors.grey),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            "${AddQuestionScreen.choiceLabels[index]}) ")
                                      ],
                                    ),
                                  )),
                            ),
                            validator: (s) {
                              if (s == null || s.isEmpty)
                                return "Add some text here ${index > 1 ? "or delete this field" : ""}";
                              return null;
                            },
                            onChange: (s) => setState(() => choices[index] = s),
                            hintText: "Edit",
                            suffixIcon: (index >= 2)
                                ? InkWell(
                                    onTap: () {
                                      if (choices.length >= 2) {
                                        setState(() {
                                          choices.removeAt(index);
                                        });
                                      }
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.clear,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          "Remove",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  fontSize: 7.5,
                                                  color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  )
                                : null,
                          );
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    MoonbaseButton(
                      text: "Choice",
                      itemsAlignment: MainAxisAlignment.start,
                      buttonPadding: const EdgeInsets.symmetric(horizontal: 25),
                      height: 40,
                      isSmallButton: true,
                      itemsGap: 20,
                      iconPrefix: Icons.add,
                      disabled: choices.length >= 4,
                      onPressed: () {
                        if (choices.length < 4) {
                          setState(() {
                            choices.add("");
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: MoonbaseButton(
                          text: "Question",
                          iconPrefix: Icons.add,
                          onPressed: () {
                            finishEdit(addAnother: true);
                          },
                        )),
                        const SizedBox(width: 20),
                        Expanded(
                            child: MoonbaseButton(
                          text: "Delete",
                          color: Colors.red,
                          textColor: Colors.white,
                          onPressed: () {
                            if (widget.onDeleteQuestion != null) {
                              showPrompt("Delete Question?",
                                  "Are you sure you want to delete this question?",
                                  onProceed: () {
                                widget.onDeleteQuestion!();
                                Navigator.pop(context);
                              }, context: context);
                            } else {
                              discardQuestion();
                            }
                          },
                        )),
                      ],
                    ),
                    const SizedBox(height: 20),
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
            color: activated ? Colors.green : Colors.grey,
            style: BorderStyle.solid,
          ),
        ));
  }
}
Future<File?> pickImageFromGalleryAndCompress(BuildContext context, {int quality=75, int minDim=350})async{
  List<String> supportedImageExtensions = [".png", ".jpg"];

  final ImagePicker picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {

    final ext = pickedFile.path.substring(pickedFile.path.lastIndexOf("."));
    if(!supportedImageExtensions.contains(ext)){
      displaySnackbar(context, msg: "Sorry $ext images are not supported");
      return null;
    }
    File image = File(pickedFile.path);
    // Compress the image


    return image;
  }

  return null;
}