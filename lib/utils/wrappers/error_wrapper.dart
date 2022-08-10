class ErrorWrapper {
  static Future<BaseResponse> asyncGuard<BaseResponse>(
    Future<BaseResponse> Function() f, {
    void Function(Object e)? onError,
  }) async {
    try {
      return await f();
    } catch (e) {
      onError?.call(e);
      rethrow;
    }
  }
}
