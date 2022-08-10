// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:io' show SocketException;

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/models/base_response.dart';
import 'package:kassku_mobile/utils/constants.dart';
import 'package:kassku_mobile/utils/exceptions.dart';
import 'package:kassku_mobile/utils/typedefs.dart';
import 'package:retry/retry.dart';

/// Base class for all the requests
class ApiServices {
  final _dio = GetIt.I<Dio>();

  /// GET the data with the given parameters
  /// it can handle any of pre request that will always require for example
  /// get token from secure storage or get the logged in user id
  Future<ResponseOfRequestMap> get(
    String api, {
    MapString? queryParameters,
    MapString? headers,
  }) async {
    try {
      final token =
          await GetIt.I<FlutterSecureStorage>().read(key: kAccessToken);

      final currentHeaders = <String, dynamic>{};

      final currentQueryParameters = <String, dynamic>{};

      if (queryParameters != null) {
        currentQueryParameters.addAll(queryParameters);
      }

      if (headers != null) {
        currentHeaders.addAll(headers);
      }

      if (token != null) {
        currentHeaders['Authorization'] = 'Bearer $token';
      }

      currentHeaders.addAll(_dio.options.headers);

      final response = await retry(
        () => _dio.get<MapString>(
          api,
          queryParameters: currentQueryParameters,
          options: Options(headers: currentHeaders),
        ),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      return ResponseOfRequest.success(data: response.data);
    } on DioError catch (e) {
      return ResponseOfRequest.error(
        data: e.response?.data,
        error: e,
      );
    } on CustomExceptionMap catch (e) {
      return ResponseOfRequest.error(data: e.cause);
    } on Exception {
      return ResponseOfRequest.error();
    }
  }

  /// POST the data with the given parameters
  /// it can handle any of pre request that will always require for example
  /// get token from secure storage or get the logged in user id
  Future<ResponseOfRequestMap> post(
    String api, {
    dynamic data,
    MapString? queryParameters,
    MapString? headers,
  }) async {
    try {
      final token =
          await GetIt.I<FlutterSecureStorage>().read(key: kAccessToken);

      final currentHeaders = <String, dynamic>{};

      final currentQueryParameters = <String, dynamic>{};

      if (queryParameters != null) {
        currentQueryParameters.addAll(queryParameters);
      }

      if (headers != null) {
        currentHeaders.addAll(headers);
      }

      if (token != null) {
        currentHeaders['Authorization'] = 'Bearer $token';
      }

      currentHeaders.addAll(_dio.options.headers);

      final response = await retry(
        () => _dio.post<MapString>(
          api,
          data: data,
          queryParameters: currentQueryParameters,
          options: Options(headers: currentHeaders),
        ),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      return ResponseOfRequest.success(data: response.data);
    } on DioError catch (e) {
      return ResponseOfRequest.error(
        data: e.response?.data,
        error: e,
      );
    } on CustomExceptionMap catch (e) {
      return ResponseOfRequest.error(data: e.cause);
    } on Exception {
      return ResponseOfRequest.error();
    }
  }

  /// PUT the data with the given parameters
  /// it can handle any of pre request that will always require for example
  /// get token from secure storage or get the logged in user id
  Future<ResponseOfRequestMap> put(
    String api, {
    MapString? data,
    MapString? queryParameters,
    MapString? headers,
  }) async {
    try {
      final token =
          await GetIt.I<FlutterSecureStorage>().read(key: kAccessToken);

      final currentHeaders = <String, dynamic>{};

      final currentQueryParameters = <String, dynamic>{};

      if (headers != null) {
        currentHeaders.addAll(headers);
      }

      if (queryParameters != null) {
        currentQueryParameters.addAll(queryParameters);
      }

      if (token != null) {
        currentHeaders['Authorization'] = 'Bearer $token';
      }

      currentHeaders.addAll(_dio.options.headers);

      final response = await retry(
        () => _dio.put<MapString>(
          api,
          data: data,
          queryParameters: currentQueryParameters,
          options: Options(headers: currentHeaders),
        ),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      return ResponseOfRequest.success(data: response.data);
    } on DioError catch (e) {
      return ResponseOfRequest.error(
        data: e.response?.data,
        error: e,
      );
    } on CustomExceptionMap catch (e) {
      return ResponseOfRequest.error(data: e.cause);
    } on Exception {
      return ResponseOfRequest.error();
    }
  }

  /// DELETE the data with the given parameters
  /// it can handle any of pre request that will always require for example
  /// get token from secure storage or get the logged in user id
  Future<ResponseOfRequestMap> delete(
    String api, {
    MapString? queryParameters,
    MapString? headers,
  }) async {
    try {
      final token =
          await GetIt.I<FlutterSecureStorage>().read(key: kAccessToken);

      final currentHeaders = <String, dynamic>{};

      final currentQueryParameters = <String, dynamic>{};

      if (headers != null) {
        currentHeaders.addAll(headers);
      }

      if (queryParameters != null) {
        currentQueryParameters.addAll(queryParameters);
      }

      if (token != null) {
        currentHeaders['Authorization'] = 'Bearer $token';
      }

      currentHeaders.addAll(_dio.options.headers);

      final response = await retry(
        () => _dio.delete<MapString>(
          api,
          queryParameters: currentQueryParameters,
          options: Options(headers: currentHeaders),
        ),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      return ResponseOfRequest.success(data: response.data);
    } on DioError catch (e) {
      return ResponseOfRequest.error(
        data: e.response?.data,
        error: e,
      );
    } on CustomExceptionMap catch (e) {
      return ResponseOfRequest.error(data: e.cause);
    } on Exception {
      return ResponseOfRequest.error();
    }
  }
}
