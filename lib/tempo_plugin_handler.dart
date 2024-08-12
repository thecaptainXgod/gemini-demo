import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moonbase_collab_upload/moonbase_collab_upload.dart';
import 'package:moonbase_explore/app_constants/custom_snackbars.dart';
import 'package:moonbase_explore/model/unit_model.dart' as tempo_explore_unit;
import 'package:moonbase_explore/model/quiz_model.dart' as tempo_explore_quiz;

import 'package:moonbase_explore/tempo_main.dart';
import 'package:moonbase_explore/widgets/common_text.dart';
import 'package:moonbase_theme/main.dart';
import 'package:moonbase_widgets/moonbase_widgets.dart';
import 'package:tempo_x/storage/draft_manager.dart';

import 'creation/bloc/quiz_creation_cubit.dart';
import 'creation/models/quiz_model.dart';
import 'creation/views/create_quizzes_screen.dart';
import 'creation/views/new_ai_quiz_screen.dart';
import 'creation/views/new_quiz_screen.dart';
import 'main.dart';
import 'models/guide_model_converter.dart';

class MoonbaseExplorePluginHandler extends StatefulWidget {
  final Widget child;

  const MoonbaseExplorePluginHandler({
    super.key,
    required this.child,
  });

  @override
  State<MoonbaseExplorePluginHandler> createState() =>
      _MoonbaseExplorePluginHandlerState();
}

class _MoonbaseExplorePluginHandlerState
    extends State<MoonbaseExplorePluginHandler> {
  @override
  void dispose() {
    // BlocProvider.of<QuizCreationCubit>(context).closeQuizCreationStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TempoExplore(
      onGuidedPreview: (guideJson) {

        saveGuideToDraft(guideJson, orgId: '12', grpId: '1', userId: '20');
      },
      onGuideSaved: (guideJson) {
        saveGuideToDraft(guideJson, orgId: '12', grpId: '1', userId: '20');
      },
      onQuizPressed: (List<tempo_explore_quiz.QuizModel> quizzes,
          List<tempo_explore_unit.Unit> units) async {
        final modifiedQuizzes =
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreateQuizzesScreen(
                      units: units,
                      quizzes: QuizModel.fromMapArray(
                          quizzes.map((e) => e.toMap()).toList()),
                    )));
        if (modifiedQuizzes != null) {
          final results = (modifiedQuizzes as List<QuizModel>);
          return results
              .map((e) => tempo_explore_quiz.QuizModel.fromMap(e.toMap()))
              .toList();
        } else {
          return null;
        }
        // createOptions(context, unitNumber, guideName, unit);
      },
      onSingleQuizPressed: (tempo_explore_quiz.QuizModel quiz,
          List<tempo_explore_unit.Unit> units, Function() onDeleteQuiz) async {
        final myQuiz = QuizModel.fromMap(quiz.toMap());
        final updatedQuiz = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => myQuiz.quizType == QuizType.aiGenerated
                ? NewAIQuizScreen(
                    quizModel: myQuiz,
                    onDeleteQuiz: onDeleteQuiz,
                    units: units,
                  )
                : NewQuizScreen(
                    quizModel: myQuiz,
                    onDeleteQuiz: onDeleteQuiz,
                  )));
        return updatedQuiz;
      },
      onSingleQuizPreview:
          (tempo_explore_quiz.QuizModel quiz, String pageTitle) {
        // getIt<NavigationService>().push(TakeQuizScreen(
        //     quizModel: QuizModel.fromMap(quiz.toMap()),
        //     pageTitle: pageTitle,
        //     isPreview: true));
      },
      quizCreationStream:
          BlocProvider.of<QuizCreationCubit>(context).initQuizCreationStream(),
      onDelete: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const MyHomePage(title: 'Moonbase Explore')));
        }

        // getIt<NavigationService>().popUntilNamed(HomeScreen.routeName);
      },
      child: widget.child,
    );
  }

  void showLoginPrompt(String guideJson) {
    showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            MoonbaseButton(
              text: "Discard guide",
              textColor: Theme.of(context).primaryColor,
              width: 200,
              color: Theme.of(context).scaffoldBackgroundColor,
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
          title: const Text(
            "Not logged in",
            textAlign: TextAlign.center,
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "It seems like you're not logged in yet. Don't worry! it takes less than a minute to set up a new account and even faster to login",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
            ],
          )),
    );
  }

  void saveGuideToDraft(String guideJson,
      {required userId, required orgId, required grpId}) {
    UGuide newGuide = convertGuideModel(guideJson,
        organizationId: orgId,
        groupId: grpId,
        createdBy: userId,
        switchQuestionImage: false);
    DraftManager draftManager = DraftManager();

    draftManager.saveDraft(newGuide);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
            const SavedDraftsScreen()));
  }
}

void publishGuide(String guideJson,
    {required String orgId, required String grpId, required String userId}) {}

Widget option(VoidCallback onTap, String text) {
  return ElevatedButton(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ),
    onPressed: () => onTap(),
  );
}
