

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_app/page_blocks/date_number_chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HistogramDateNumberChartBlock extends StatefulWidget {
  final chartData;

  const HistogramDateNumberChartBlock({super.key,this.chartData});

  @override
  _HistogramDateNumberChartBlockState createState() => _HistogramDateNumberChartBlockState();
}

class _HistogramDateNumberChartBlockState extends State<HistogramDateNumberChartBlock> {
  late TooltipBehavior _tooltipBehavior;
  late List<DateNumberChartData> _chartData;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = widget.chartData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child:Column(
          children: [
            Expanded(
              child:SfCartesianChart(
                  primaryXAxis: DateTimeCategoryAxis(),
                  tooltipBehavior: _tooltipBehavior,
                  series: <ChartSeries<DateNumberChartData, DateTime>>[
                    ColumnSeries<DateNumberChartData, DateTime>(
                        dataSource: _chartData,
                        xValueMapper: (DateNumberChartData data, _) => data.xValue,
                        yValueMapper: (DateNumberChartData data, _) => data.yValue
                    )
                  ]
              ),
            )
          ],
        )
    );
  }
}
