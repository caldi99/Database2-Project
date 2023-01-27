import 'package:flutter/cupertino.dart';
import 'package:flutter_web_app/classes/string_integer_chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;


class HistogramStringIntegerChartBlock extends StatefulWidget {
  final chartData;
  final nameTooltip;
  final descriptionXAxis;
  final descriptionYAxis;
  final minValueY;
  final maxValueY;
  final intervalValueY;

  const HistogramStringIntegerChartBlock({super.key,this.chartData,this.nameTooltip,this.descriptionXAxis,
  this.descriptionYAxis,this.minValueY,this.maxValueY,this.intervalValueY});

  @override
  _HistogramStringIntegerChartBlockState createState() => _HistogramStringIntegerChartBlockState();
}

class _HistogramStringIntegerChartBlockState extends State<HistogramStringIntegerChartBlock> {
  late TooltipBehavior _tooltipBehavior;
  late final List<StringIntegerChartData> _chartData;
  late final _nameToolTip;
  late final _descriptionXAxis;
  late final _descriptionYAxis;
  late final _minValueY;
  late final _maxValueY;
  late final _intervalValueY;

  @override
  void initState(){
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = widget.chartData;
    _descriptionXAxis = widget.descriptionXAxis;
    _descriptionYAxis = widget.descriptionYAxis;
    _nameToolTip = widget.nameTooltip;
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
        child:Column(
          children: [
            Expanded(
              child:SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
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
                  series: <ChartSeries<StringIntegerChartData, String>>[
                    ColumnSeries<StringIntegerChartData, String>(
                        dataSource: _chartData,
                        xValueMapper: (StringIntegerChartData data, _) => data.xValue,
                        yValueMapper: (StringIntegerChartData data, _) => data.yValue,
                        pointColorMapper: (StringIntegerChartData data, _) => data.color,
                        name: _nameToolTip,
                        borderRadius: constants.BLOCK_PAGES_COLUMNSERIES_BORDERRADIUS_STYLE
                    ),
                  ]
              ),
            ),
            Text(
                _descriptionXAxis,
                style: constants.BLOCK_PAGES_DESCRIPTION_AXIS_STYLE
            ),
          ],
        )
    );
  }
}
