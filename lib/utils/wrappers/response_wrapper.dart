import 'package:kassku_mobile/models/base_response.dart';
import 'package:kassku_mobile/utils/enums.dart';
import 'package:kassku_mobile/utils/exceptions.dart';
import 'package:kassku_mobile/utils/typedefs.dart';

class ResponseWrapper {
  static T guard<T, S>(
    ResponseOfRequest<S> response, {
    void Function(Object e)? onError,
  }) {
    assert(
      T == MapString || T == List<MapString>,
      'T must be MapString or List',
    );
    assert(
      S == MapString || S == List<MapString>,
      'S must be MapString or List',
    );

    try {
      if (response.status == ResponseStatus.success) {
        final data = response.data! as MapString;

        if (T == List<MapString>) {
          final raw = data['data'] as List<dynamic>;
          return raw.map((e) => e as MapString).toList() as T;
        }

        final raw = data['data'] as T;
        return raw;
      }
      throw CustomExceptionString(response.message ?? 'Unknown error');
    } catch (e) {
      onError?.call(e);
      rethrow;
    }
  }
}
