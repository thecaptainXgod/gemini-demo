import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'freezed_files/network_exceptions.freezed.dart';

@freezed
abstract class NetworkExceptions with _$NetworkExceptions {
  const factory NetworkExceptions.requestCancelled() = RequestCancelled;

  const factory NetworkExceptions.unauthorisedRequest() = UnauthorisedRequest;

  const factory NetworkExceptions.badRequest() = BadRequest;

  const factory NetworkExceptions.notFound(String reason) = NotFound;

  const factory NetworkExceptions.methodNotAllowed() = MethodNotAllowed;

  const factory NetworkExceptions.notAcceptable() = NotAcceptable;

  const factory NetworkExceptions.requestTimeout() = RequestTimeout;

  const factory NetworkExceptions.sendTimeout() = SendTimeout;

  const factory NetworkExceptions.conflict() = Conflict;

  const factory NetworkExceptions.internalServerError() = InternalServerError;

  const factory NetworkExceptions.notImplemented() = NotImplemented;

  const factory NetworkExceptions.serviceUnavailable() = ServiceUnavailable;

  const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;

  const factory NetworkExceptions.formatException() = FormatException;

  const factory NetworkExceptions.unableToProcess() = UnableToProcess;

  const factory NetworkExceptions.defaultError(String error) = DefaultError;

  const factory NetworkExceptions.unexpectedError() = UnexpectedError;

  static NetworkExceptions getDioException(error) {
    if (error.toString().contains("is not a subtype of")) {
      return NetworkExceptions.defaultError(error.toString());
    }
    if(error is String ){
      return NetworkExceptions.defaultError(error);
    }else if (error.message is DioException) {
      NetworkExceptions networkExceptions;
      try {
        switch (error.message.type as DioExceptionType) {
          case DioExceptionType.cancel:
            networkExceptions = const NetworkExceptions.requestCancelled();
            break;
          case DioExceptionType.connectionTimeout:
            networkExceptions = const NetworkExceptions.requestTimeout();
            break;
          case DioExceptionType.unknown:
            networkExceptions = const NetworkExceptions.noInternetConnection();
            break;
          case DioExceptionType.receiveTimeout:
            networkExceptions = const NetworkExceptions.sendTimeout();
            break;
          case DioExceptionType.badResponse:
            networkExceptions = NetworkExceptions.defaultError(error.message.response.data['message'] ?? error.message.response.data['response'] ?? "An unknown error occurred");
            break;
          case DioExceptionType.sendTimeout:
            networkExceptions = const NetworkExceptions.sendTimeout();
            break;
          case DioExceptionType.badCertificate:
            networkExceptions = const NetworkExceptions.badRequest();
            break;
          case DioExceptionType.connectionError:
            networkExceptions = const NetworkExceptions.requestTimeout();
            break;
        }
      } catch (e) {
        return const NetworkExceptions.unableToProcess();
      }

      return networkExceptions;
    } else if (error is Exception) {
      try {
        NetworkExceptions networkExceptions;
        if (error is SocketException) {
          networkExceptions = const NetworkExceptions.noInternetConnection();
        } else {
          networkExceptions = const NetworkExceptions.unexpectedError();
        }
        return networkExceptions;
      } on FormatException {
        // Helper.printError(e.toString());
        return const NetworkExceptions.formatException();
      } catch (_) {
        return const NetworkExceptions.unexpectedError();
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return const NetworkExceptions.unableToProcess();
      } else {
        return const NetworkExceptions.unexpectedError();
      }
    }
  }

  static String getErrorMessage(NetworkExceptions networkExceptions) {
    var errorMessage = "";
    networkExceptions.when(notImplemented: () {
      errorMessage = "Not Implemented";
    }, requestCancelled: () {
      errorMessage = "Request Cancelled";
    }, internalServerError: () {
      errorMessage = "Internal Server Error";
    }, notFound: (String reason) {
      errorMessage = reason;
    }, serviceUnavailable: () {
      errorMessage = "Service unavailable";
    }, methodNotAllowed: () {
      errorMessage = "Method Allowed";
    }, badRequest: () {
      errorMessage = "Bad request";
    }, unauthorisedRequest: () {
      errorMessage = "Unauthorised request";
    }, unexpectedError: () {
      errorMessage = "Unexpected error occurred";
    }, requestTimeout: () {
      errorMessage = "Connection request timeout";
    }, noInternetConnection: () {
      errorMessage = "No internet connection";
    }, conflict: () {
      errorMessage = "Error due to a conflict";
    }, sendTimeout: () {
      errorMessage = "Send timeout in connection with API server";
    }, unableToProcess: () {
      errorMessage = "Unable to process the data";
    }, defaultError: (String error) {
      errorMessage = error;
    }, formatException: () {
      errorMessage = "Unexpected error occurred";
    }, notAcceptable: () {
      errorMessage = "Not acceptable";
    });
    return errorMessage;
  }
}
