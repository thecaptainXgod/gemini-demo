import 'dart:async';

import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../models/guide_ai.dart';
import '../networking/ai_dio_client.dart';
import '../networking/api_result.dart';
import '../networking/network_exceptions.dart';
import 'home_base_repository.dart';

class HomeRepository implements HomeBaseRepository {
  final AIDioClient _aiDioClient = AIDioClient();

  @override
  Future<ApiResult<GuideAi>> createGuideUsingAI(
      {required String prompt,
      required String units,
      required String videosPerUnit}) async {
    try {
      final response = await _aiDioClient
          .post(ApiConstants.postCreateGuideUsingAI, data: {
        "prompt": prompt,
        "units": units,
        "videos_per_unit": videosPerUnit
      });
      return ApiResult.success(data: GuideAi.fromJson(response));
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
