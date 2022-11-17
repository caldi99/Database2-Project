import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_app/classes/date_integer_chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;


class HistogramDateIntegerChartBlock extends StatefulWidget {
  final chartData;
  final nameTooltip;
  final descriptionXAxis;
  final descriptionYAxis;
  final minValueY;
  final maxValueY;
  final intervalValueY;
  const HistogramDateIntegerChartBlock({super.key,this.chartData,this.intervalValueY,
  this.maxValueY,this.minValueY,this.descriptionYAxis,this.descriptionXAxis,this.nameTooltip});

  @override
  _HistogramDateIntegerChartBlockState createState() => _HistogramDateIntegerChartBlockState();
}

class _HistogramDateIntegerChartBlockState extends State<HistogramDateIntegerChartBlock> {
  //DATA MEMBERS
  late TooltipBehavior _tooltipBehavior;
  late List<DateIntegerChartData> _chartData;
  late final _nameTooltip;
  late final _descriptionXAxis;
  late final _descriptionYAxis;
  late final _minValueY;
  late final _maxValueY;
  late final _intervalValueY;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = widget.chartData;
    _nameTooltip = widget.nameTooltip;
    _descriptionXAxis = widget.descriptionXAxis;
    _descriptionYAxis = widget.descriptionYAxis;
    _minValueY = widget.minValueY;
    _maxValueY = widget.maxValueY;
    _intervalValueY = widget.intervalValueY;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: constants.BLOCK_PAGES_CONTAINER_PADDING_STYLE,
        decoration: constants.BLOCK_PAGES_CONTAINER_DECORATION_STYLE,
        child:Column(children: [
          Expanded(
                  child:SfCartesianChart(
                  primaryXAxis: DateTimeCategoryAxis(),
                  primaryYAxis: NumericAxis(
                      minimum: _minValueY,
                      maximum: _maxValueY,
                      interval: _intervalValueY,
                      title: AxisTitle(
                          text:_descriptionYAxis,
                          textStyle: constants.BLOCK_PAGES_DESCRIPTION_AXIS_STYLE
                      )
                  ),
                  tooltipBehavior: _tooltipBehavior,
                  series: <ChartSeries<DateIntegerChartData, DateTime>>[
                    ColumnSeries<DateIntegerChartData, DateTime>(
                      dataSource: _chartData,
                      xValueMapper: (DateIntegerChartData data, _) => data.xValue,
                      yValueMapper: (DateIntegerChartData data, _) => data.yValue,
                        pointColorMapper: (DateIntegerChartData data, _) => data.color,
                      name: _nameTooltip,
                      borderRadius: constants.BLOCK_PAGES_COLUMNSERIES_BORDERRADIUS_STYLE
                  )
                 ]
              ),
            ),
            Text(
              _descriptionXAxis,
              style : constants.BLOCK_PAGES_DESCRIPTION_AXIS_STYLE
            )
          ],
        )
    );
  }
}
