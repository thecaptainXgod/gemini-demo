import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:moonbase_explore/app_constants/custom_snackbars.dart';

import '../constants/api_constants.dart';



const _defaultConnectTimeout = Duration(seconds: 60);
const _defaultReceiveTimeout = Duration(seconds: 60);

class AIDioClient {
  final String baseUrl =
      "${ApiConstants.prodAIBaseUrl}${ApiConstants.apiVersion}";

  Dio? _dio;
  static final AIDioClient _instance = AIDioClient._internal();

  factory AIDioClient() {
    return _instance;
  }

  AIDioClient._internal() {
    _dio = Dio();
    _dio!
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = _defaultConnectTimeout
      ..options.receiveTimeout = _defaultReceiveTimeout
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

    if (kDebugMode) {
      _dio!.interceptors.add(
        LogInterceptor(
            responseBody: true,
            error: true,
            requestHeader: false,
            responseHeader: false,
            request: false,
            requestBody: false),
      );
    }

    _dio!.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (error, handler) async {
        return handler.next(error);
      },
    ));


  }

  setBaseUrl(baseUrl) {
    _dio!.options.baseUrl = baseUrl;
  }

  initToken(String token) {
    _dio!.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
  }

  Future<dynamic> get(String uri,
      {Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
  
      final response = await _dio!.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );


      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException();
    } catch (e) {
   
      throw Exception(e);
    }
  }

  Future<dynamic> post(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
     }) async {
    try {
  
      final response = await _dio!.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    
      return response.data;
    } on FormatException catch (_) {
      throw const FormatException();
    } catch (e) {
   
      throw Exception(e);
    }
  }

  Future<dynamic> patch(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
     }) async {
    try {
  
      final response = await _dio!.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return response.data;
    } on FormatException catch (_) {
      throw const FormatException();
    } catch (e) {
   
      if (e is DioExceptionType) {
        throw Exception(e);
      } else {
        throw Exception(e);
      }
    }
  }

  Future<dynamic> put(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
     }) async {
    try {
  
      final response = await _dio!.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return response.data;
    } on FormatException catch (_) {
      throw const FormatException();
    } catch (e) {
   

      throw Exception(e);
    }
  }

  Future<dynamic> delete(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
     }) async {
    try {
  
      final response = await _dio!.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on FormatException catch (_) {
      throw const FormatException();
    } catch (e) {
   
      if (e is DioExceptionType) {
        throw Exception(e.toString());
      } else {
        throw Exception(e);
      }
    }
  }
}


