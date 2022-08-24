import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kassku_mobile/gen/colors.gen.dart';
import 'package:kassku_mobile/modules/transactions/bloc/transactions_chart_bloc.dart';
import 'package:kassku_mobile/utils/functions.dart';
import 'package:logger/logger.dart';

class TransactionChartWidget extends StatelessWidget {
  const TransactionChartWidget({
    Key? key,
    required this.workspaceId,
  }) : super(key: key);

  final String workspaceId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionsChartBloc()
        ..add(
          FetchTransactionsChartEvent(
            workspaceId,
            DateTime.now().subtract(const Duration(days: 30)),
            DateTime.now(),
          ),
        ),
      child: const _TransactionChartBodyWidget(),
    );
  }
}

class _TransactionChartBodyWidget extends StatefulWidget {
  const _TransactionChartBodyWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => __TransactionChartBodyWidgetState();
}

class __TransactionChartBodyWidgetState
    extends State<_TransactionChartBodyWidget> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 9;

  List<BarChartGroupData> rawBarGroups = [];
  List<BarChartGroupData> showingBarGroups = [];

  int touchedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TransactionsChartBloc>().state;

    Widget widget = const SizedBox();

    if (state is TransactionsChartLoading) {
      widget = const Center(child: CircularProgressIndicator());
    } else if (state is TransactionsChartLoaded) {
      widget = AspectRatio(
        aspectRatio: 1,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: ColorName.secondary,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    makeTransactionsIcon(),
                    const SizedBox(
                      width: 38,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Transaksi',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        Text(
                          '30 hari terakhir',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 11,
                              width: 11,
                              color: leftBarColor,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text(
                              'Pemasukan',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              height: 11,
                              width: 11,
                              color: rightBarColor,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text(
                              'Pengeluaran',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 38,
                ),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.grey,
                          getTooltipItem: (_a, _b, _c, _d) => null,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: bottomTitles,
                            reservedSize: 42,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: leftTitles,
                            reservedSize: 72,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                      gridData: FlGridData(show: true),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return BlocListener<TransactionsChartBloc, TransactionsChartState>(
      listener: (context, state) {
        if (state is TransactionsChartLoaded) {
          final items = state.transactionsChart
              .map(
                (e) => makeGroupData(
                  e.x.millisecondsSinceEpoch,
                  e.y1.toDouble(),
                  e.y2.toDouble(),
                ),
              )
              .toList();

          rawBarGroups = items;

          showingBarGroups = rawBarGroups;

          if (showingBarGroups.isEmpty) {
            final initialBar = BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: 0,
                  color: leftBarColor,
                  width: width,
                ),
                BarChartRodData(
                  toY: 0,
                  color: rightBarColor,
                  width: width,
                ),
              ],
            );

            showingBarGroups.add(initialBar);
          }
        }
      },
      child: widget,
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(currencyFormatterNoLeading.format(value), style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final millis = value.toInt();
    final date = DateTime.fromMillisecondsSinceEpoch(millis);
    final ft = DateFormat('dd/MM', 'id');

    final text = Text(
      ft.format(date),
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        toY: y1,
        color: leftBarColor,
        width: width,
      ),
      BarChartRodData(
        toY: y2,
        color: rightBarColor,
        width: width,
      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}
