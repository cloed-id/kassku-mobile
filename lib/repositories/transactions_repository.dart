import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/helpers/user_helper.dart';
import 'package:kassku_mobile/models/base_response.dart';
import 'package:kassku_mobile/models/transaction.dart';
import 'package:kassku_mobile/repositories/base_repository.dart';
import 'package:kassku_mobile/utils/constants.dart';
import 'package:kassku_mobile/utils/enums.dart';
import 'package:kassku_mobile/utils/typedefs.dart';

class TransactionsRepository extends BaseRepository {
  Future<BaseResponse<List<Transaction>>> getTransactions(
    String key,
    String workspaceId,
    String? memberWorkspaceId,
  ) async {
    final response = await get(
      '${ApiEndPoint.kApiWorkspaces}/$workspaceId/${ApiEndPoint.kApiTransactions}',
      queryParameters: <String, String>{
        // 'search_columns': 'name',
        // 'search_key': key,
        if (memberWorkspaceId != null) 'member_workspace_id': memberWorkspaceId,
        'page': '1',
        'per_page': '100',
      },
    );

    final result = responseWrapper<List<MapString>, MapString>(response);

    final transactions = result.map(Transaction.fromJson).toList();

    return BaseResponse.success(transactions);
  }

  Future<BaseResponse<Transaction>> createTransaction(
    String workspaceId,
    String memberWorkspaceId,
    String categoryId,
    String description,
    int amount,
    TransactionType type,
  ) async {
    final response = await post(
      '${ApiEndPoint.kApiWorkspaces}/$workspaceId/${ApiEndPoint.kApiTransactions}',
      data: <String, dynamic>{
        'member_workspace_id': memberWorkspaceId,
        'category_id': categoryId,
        'transaction_type': type.name.toUpperCase(),
        'description': description,
        'amount': amount,
        'description_lang': GetIt.I<UserHelper>().lang,
      },
    );

    final result = responseWrapper<MapString, MapString>(response);

    final workspace = Transaction.fromJson(result);

    return BaseResponse.success(workspace);
  }
}
