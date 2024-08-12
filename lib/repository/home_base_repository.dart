

import '../models/guide_ai.dart';
import '../networking/api_result.dart';


abstract class HomeBaseRepository {

  Future<ApiResult<GuideAi>> createGuideUsingAI(
      {required String prompt, required String units, required String videosPerUnit});
}
