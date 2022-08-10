import 'package:kassku_mobile/models/base_response.dart';
import 'package:kassku_mobile/services/api_services.dart';
import 'package:kassku_mobile/utils/typedefs.dart';
import 'package:kassku_mobile/utils/wrappers/response_wrapper.dart';

abstract class DataTableRepository<M> extends BaseRepository {
  Future<BaseResponse<List<M>>> getDatatable(
    String key,
    String filter,
    MapStringValue sorts,
    int perPage,
    int page,
  );

  Future<BaseResponse<MapString>> deleteDatatable(String id);
}

abstract class BaseRepository extends ApiServices {
  T responseWrapper<T, S>(
    ResponseOfRequest<S> response, {
    void Function(Object e)? onError,
  }) =>
      ResponseWrapper.guard(response, onError: onError);
}
