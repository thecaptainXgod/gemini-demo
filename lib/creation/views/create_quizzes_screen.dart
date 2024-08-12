import 'package:flutter/material.dart';

import 'package:moonbase_explore/model/models.dart';
import 'package:moonbase_explore/utils/utility.dart';
import 'package:moonbase_explore/widgets/common_app_bar.dart';
import 'package:moonbase_theme/decorations/decorations.dart';
import 'package:moonbase_widgets/moonbase_widgets.dart';

import '../models/quiz_model.dart';
import 'new_ai_quiz_screen.dart';
import 'new_quiz_screen.dart';

class CreateQuizzesScreen extends StatefulWidget {
  final List<Unit>? units;
  final List<QuizModel>? quizzes;

  const CreateQuizzesScreen({this.units, this.quizzes, super.key});

  @override
  State<CreateQuizzesScreen> createState() => _CreateQuizzesScreenState();
}

class _CreateQuizzesScreenState extends State<CreateQuizzesScreen> {

  List<QuizModel> quizzes = [
  ];

  @override
  void initState() {
    if (widget.quizzes != null) {
      quizzes = widget.quizzes!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(preferredSize: Size(MediaQuery
              .of(context)
              .size
              .width, kToolbarHeight),
            child: const TAppBar(buildBackButton: true, title: "Quizzes",),),
          floatingActionButton: quizzes.isEmpty ? null : MoonbaseFab(
            child: const Icon(Icons.done), onPressed: () {
            Navigator.pop(context, quizzes);
          },),
          body: Container(
            padding: const EdgeInsets.all(15),
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            decoration: starsDecoration,
            child: Column(
              children: [

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MoonbaseFab(
                      onPressed: () async {
                        final newQuiz = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (
                                context) => const NewQuizScreen()));
                            if(newQuiz !=null)
                        {
                          setState(() {
                            quizzes.add(newQuiz);
                          });
                        }
                      },
                      isCircular: true,
                      label: "New Quiz",
                      child: const Icon(Icons.add),
                    ),
                    // MoonbaseFab(
                    //   onPressed: ()async{
                    //     if(widget.units == null || widget.units!.isEmpty){
                    //       displaySnackbar(context, msg: "Sorry, your guide does not contain any units. Please add one to use this feature");
                    //       return;
                    //     }
                    //     final newQuiz = await getIt<NavigationService>().push(NewAIQuizScreen(units: widget.units!,));
                    //     if(newQuiz !=null){
                    //       setState(() {
                    //         quizzes.add(newQuiz);
                    //       });
                    //     }
                    //   },
                    //   isCircular: true,
                    //   label: "AI-Generated Quiz",
                    //   backgroundColor: const Color(0xffDE86FE),
                    //   child: const Icon(Icons.add),
                    // ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 0.5,),
                Align(alignment: Alignment.topLeft, child: Wrap(
                    runAlignment: WrapAlignment.start,
                    alignment: WrapAlignment.start,
                    spacing: 5,
                    runSpacing: 10,
                    children: List.generate(quizzes.length, (index) =>
                        MoonbaseFab(onPressed: () async {
                          onDeleteQuiz() async {
                            await showAlertDailog(context,
                                "Are you sure you want to delete this quiz?",
                                successOption: "Delete",
                                cancelOption: "Cancel",
                                onSuccess: () {
                                  Navigator.pop(context);
                                  Future.delayed(
                                      const Duration(milliseconds: 500), () {
                                    setState(() {
                                      quizzes.removeAt(index);
                                    });
                                    Navigator.pop(context);
                                  });
                                },
                                onCancel: () {
                                  Navigator.pop(context);
                                });
                          }

                          final updatedQuiz = await Navigator.of(context)
                              .push(
                            MaterialPageRoute(builder: (context) =>
                              quizzes[index].quizType == QuizType.aiGenerated ?
                              NewAIQuizScreen(quizModel: quizzes[index],
                                onDeleteQuiz: onDeleteQuiz,
                                units: widget.units ?? [],) :
                              NewQuizScreen(quizModel: quizzes[index],
                                onDeleteQuiz: onDeleteQuiz,)
                          ));

                          if (updatedQuiz != null) {
                            setState(() {
                              quizzes[index] = updatedQuiz;
                            });
                          }
                        },
                          isCircular: true,
                          label: quizzes[index].quizTitle,
                          subtitle: "${quizzes[index].questions
                              .length} question${quizzes[index].questions
                              .length != 1 ? "s" : ""}",
                          backgroundColor: getColorForString(quizzes[index]
                              .quizTitle.toLowerCase()
                              .replaceAll(" ", "")),
                          child: const SizedBox(),))
                ),),
              ],
            ),
          )
      ),
    );
  }
}
