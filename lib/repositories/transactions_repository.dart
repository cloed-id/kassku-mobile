import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/helpers/analytics_helper.dart';
import 'package:kassku_mobile/helpers/user_helper.dart';
import 'package:kassku_mobile/models/base_response.dart';
import 'package:kassku_mobile/models/transaction.dart';
import 'package:kassku_mobile/models/transaction_chart.dart';
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

  Future<BaseResponse<List<TransactionChartXY1Y2>>> getTransactionsChart(
    String workspaceId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final df = DateFormat('yyyy-MM-dd HH:mm:ss');
    final response = await get(
      '${ApiEndPoint.kApiWorkspaces}/$workspaceId/${ApiEndPoint.kApiTransactions}/chart',
      queryParameters: <String, String>{
        'start_date': df.format(startDate),
        'end_date': df.format(endDate)
      },
    );

    final result = responseWrapper<List<MapString>, MapString>(response);

    final transactions = result.map(TransactionChart.fromJson).toList();

    final trxChart = <TransactionChartXY1Y2>[];

    for (final transaction in transactions) {
      final x = transaction.date;
      num y1 = 0;
      num y2 = 0;

      if (transaction.transactionType == TransactionType.income) {
        y1 = transaction.amount;
      } else {
        y2 = transaction.amount;
      }

      if (trxChart.isEmpty) {
        trxChart.add(TransactionChartXY1Y2(x, y1, y2));
      } else {
        final last = trxChart.last;
        if (last.x.day == x.day &&
            last.x.month == x.month &&
            last.x.year == x.year) {
          last
            ..y1 += y1
            ..y2 += y2;

          trxChart[trxChart.length - 1] = last;
        } else {
          trxChart.add(TransactionChartXY1Y2(x, y1, y2));
        }
      }
    }
    return BaseResponse.success(trxChart);
  }

  Future<BaseResponse<Transaction>> createTransaction(
    String workspaceId,
    String memberWorkspaceId,
    String categoryId,
    String description,
    int amount,
    TransactionType type,
  ) async {
    await AnalyticsHelper.logEvent(
      name: 'create_transaction',
      parameters: <String, dynamic>{
        'amount': amount,
        'type': type.name,
      },
    );
    
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
