import 'dart:convert';

import 'package:moonbase_collab_upload/moonbase_collab_upload.dart';

UGuide convertGuideModel(String oldJsonFormat,
    {required String organizationId,
    required String groupId,
    required String createdBy,
    bool switchQuestionImage = true}) {
  Map<String, dynamic> guideMap = jsonDecode(oldJsonFormat);

  List<Unit> units = <Unit>[];
  List<UQuiz> quizzes = <UQuiz>[];
  if (guideMap['units'] != null) {
    for (Map<String, dynamic> unitMap in guideMap['units']) {
      Unit unit = Unit.fromMap(unitMap);
      units.add(unit);
    }
  }

  if (guideMap['quizzes'] != null) {
    for (Map<String, dynamic> quizMap in guideMap['quizzes']) {
      UQuiz quiz =
          UQuiz.fromMap(quizMap, switchQuestionImage: switchQuestionImage);
      quizzes.add(quiz);
    }
  }

  UGuide uGuide = UGuide(
    id: guideMap['id'],
    organizationId: organizationId,
    groupId: groupId,
    createdBy: createdBy,
    guideName: guideMap['title'],
    description: guideMap['description'],
    status: UGuideStatus.uninitialised,
    error: null,
    trailerVideo: VideoDetails(
      coverImagePath: '',
      localCoverImagePath: guideMap['trailer_video']['coverImagePath'],
      videoPath: '',
      localPath: guideMap['trailer_video']['videoPath'],
    ),
    units: units,
    quizzes: quizzes,
  );
  return uGuide;
}
