import 'package:flutter/cupertino.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;
import 'package:syncfusion_flutter_charts/charts.dart';

import '../classes/string_integer_chart_data.dart';

class PieChartBlock extends StatelessWidget {

  //DATA MEMBERS
  final title;
  final chartData;

  const PieChartBlock({
  super.key,this.title,this.chartData
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: constants.BLOCK_PAGES_CONTAINER_PADDING_STYLE,
        decoration: constants.BLOCK_PAGES_CONTAINER_DECORATION_STYLE,
        child:Column(
            children: [
              Expanded(
                child :
                  SfCircularChart(
                    title: ChartTitle(text: title),
                    legend: Legend(isVisible: true,overflowMode: LegendItemOverflowMode.wrap,position: LegendPosition.bottom),
                    series: <CircularSeries>[
                      PieSeries<StringIntegerChartData, String>(
                        dataSource: chartData,
                        xValueMapper: (StringIntegerChartData data, _) => data.xValue,
                        yValueMapper: (StringIntegerChartData data, _) => data.yValue,
                          pointColorMapper: (StringIntegerChartData data, _) => data.color,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        enableTooltip: true
                      )
                    ]
                  )
              )
            ]
          )
    );
  }
}