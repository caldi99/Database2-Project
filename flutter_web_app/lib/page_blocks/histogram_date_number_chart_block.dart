import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_app/classes/date_number_chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;


class HistogramDateNumberChartBlock extends StatefulWidget {
  final chartData;
  final seriesName;

  const HistogramDateNumberChartBlock({super.key,this.chartData,this.seriesName});

  @override
  _HistogramDateNumberChartBlockState createState() => _HistogramDateNumberChartBlockState();
}

class _HistogramDateNumberChartBlockState extends State<HistogramDateNumberChartBlock> {
  //DATA MEMBERS
  late TooltipBehavior _tooltipBehavior;
  late List<DateNumberChartData> _chartData;
  late String seriesName;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = widget.chartData;
    seriesName=widget.seriesName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: constants.BLOCK_PAGES_CONTAINER_PADDING_PROPRIETY,
        decoration: constants.BLOCK_PAGES_CONTAINER_DECORATION_PROPRIETY,
        child:Column(children: [
          Expanded(
            child:SfCartesianChart(
                primaryXAxis: DateTimeCategoryAxis(),
                tooltipBehavior: _tooltipBehavior,
                series: <ChartSeries<DateNumberChartData, DateTime>>[
                  ColumnSeries<DateNumberChartData, DateTime>(
                      dataSource: _chartData,
                      name:seriesName,
                      xValueMapper: (DateNumberChartData data, _) => data.xValue,
                      yValueMapper: (DateNumberChartData data, _) => data.yValue,
                      pointColorMapper: (DateNumberChartData data, _) => data.color,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(3),topRight: Radius.circular(3))
                  )
                ]
            ),
          )
        ],
        )
    );
  }
}
