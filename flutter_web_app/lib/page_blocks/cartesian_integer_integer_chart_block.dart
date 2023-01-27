import 'package:flutter/cupertino.dart';
import 'package:flutter_web_app/classes/string_integer_chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;


class CartesianIntegerIntegerChartBlock extends StatefulWidget {
  final chartData; //List<List<Integer,Integer>>
  final nameTooltips;
  final descriptionXAxis;
  final descriptionYAxis;
  final minValueY;
  final maxValueY;
  final intervalValueY;

  const CartesianIntegerIntegerChartBlock({super.key,this.chartData,this.nameTooltips,this.descriptionXAxis,
  this.descriptionYAxis,this.minValueY,this.maxValueY,this.intervalValueY});

  @override
  _CartesianIntegerIntegerChartBlockState createState() => _CartesianIntegerIntegerChartBlockState();
}

class _CartesianIntegerIntegerChartBlockState extends State<CartesianIntegerIntegerChartBlock> {
  late TooltipBehavior _tooltipBehavior;
  late final List<List<StringIntegerChartData>> _chartData;
  late final List<String> _nameToolTips;
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
    _nameToolTips = widget.nameTooltips;
    _minValueY = widget.minValueY;
    _maxValueY = widget.maxValueY;
    _intervalValueY = widget.intervalValueY;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    int i= 0;
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
                  legend: Legend(isVisible: true,overflowMode: LegendItemOverflowMode.wrap,position: LegendPosition.bottom),
                  series:
                    <CartesianSeries>
                      [

                        for (var data in _chartData) ... [
                          LineSeries<StringIntegerChartData,String>(
                              dataSource: data,
                              xValueMapper: (StringIntegerChartData data, _) => data.xValue,
                              yValueMapper: (StringIntegerChartData data, _) => data.yValue,
                              pointColorMapper: (StringIntegerChartData data, _) => data.color,
                              name: _nameToolTips[i++],
                          )
                        ]
                      ]
              )
            ),
            Text(
                _descriptionXAxis,
                style : constants.BLOCK_PAGES_DESCRIPTION_AXIS_STYLE
            )
          ]
        )
    );
  }
}
