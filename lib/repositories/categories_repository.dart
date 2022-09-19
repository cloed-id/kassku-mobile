import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/helpers/analytics_helper.dart';
import 'package:kassku_mobile/helpers/user_helper.dart';
import 'package:kassku_mobile/models/base_response.dart';
import 'package:kassku_mobile/models/category.dart';
import 'package:kassku_mobile/repositories/base_repository.dart';
import 'package:kassku_mobile/utils/constants.dart';
import 'package:kassku_mobile/utils/enums.dart';
import 'package:kassku_mobile/utils/exceptions.dart';
import 'package:kassku_mobile/utils/typedefs.dart';

class CategoriesRepository extends BaseRepository {
  Future<BaseResponse<List<Category>>> getCategories(
    String key,
    String workspaceId,
  ) async {
    final response = await get(
      '${ApiEndPoint.kApiWorkspaces}/$workspaceId/${ApiEndPoint.kApiCategories}',
      queryParameters: <String, String>{
        // 'search_columns': 'name',
        // 'search_key': key,
        'page': '1',
        'per_page': '10',
      },
    );

    final result = responseWrapper<List<MapString>, MapString>(response);

    final categories = result.map(Category.fromJson).toList();

    return BaseResponse.success(categories);
  }

  Future<BaseResponse<Category>> createCategory(
    String name,
    String workspaceId,
  ) async {
    await AnalyticsHelper.logEvent(name: 'create_category');

    final lang = GetIt.I<UserHelper>().lang;
    final response = await post(
      '${ApiEndPoint.kApiWorkspaces}/$workspaceId/${ApiEndPoint.kApiCategories}',
      data: <String, dynamic>{
        'name': name,
        'lang': lang,
      },
    );

    final result = responseWrapper<MapString, MapString>(response);

    final category = Category.fromJson(result);

    return BaseResponse.success(category);
  }

  Future<void> deleteCategory(
    String categoryId,
    String workspaceId,
  ) async {
    await AnalyticsHelper.logEvent(name: 'delete_category');

    final response = await delete(
      '${ApiEndPoint.kApiWorkspaces}/$workspaceId/${ApiEndPoint.kApiCategories}/$categoryId',
    );

    if (response.status == ResponseStatus.success) {
      return;
    }

    throw CustomExceptionString(response.message ?? 'Unknown error');
  }
}
