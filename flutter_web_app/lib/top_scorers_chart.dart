import 'package:flutter/material.dart';
import 'package:flutter_web_app/query_handler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_web_app/constants.dart' as constants;

class TopScorersChart extends StatefulWidget {
  const TopScorersChart({ super.key, this.data });
  final data;

  @override
  State<TopScorersChart> createState() => _TopScorersChart();
}

class _TopScorersChart extends State<TopScorersChart> {

  late TooltipBehavior _tooltipBehavior;
  late final List<TopScorersChartData> data;


  @override
  void initState(){
    _tooltipBehavior = TooltipBehavior(enable: true);
    data=widget.data;
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
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child:Column(
          children: [
            Expanded(
              child:SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(minimum: 0, maximum: 45000, interval: 5000,title: AxisTitle(text:"#Points",textStyle: TextStyle(fontSize: 13,fontWeight: FontWeight.w300))),
                  tooltipBehavior: _tooltipBehavior,

                  series: <ChartSeries<TopScorersChartData, String>>[
                    ColumnSeries<TopScorersChartData, String>(
                        dataSource: data,
                        xValueMapper: (TopScorersChartData data, _) => data.name,
                        yValueMapper: (TopScorersChartData data, _) => data.pointsScored                                                                                ,
                        name: 'Scored points',
                        pointColorMapper: (TopScorersChartData data, _) => data.color,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5))
                    ),
                  ]
              ),
            ),
            const Text(
                "The Top 10 scorers with their corresponding number of scored points",
                style:TextStyle(fontWeight: FontWeight.normal,fontSize: 14,height: 1.2)
            ),
          ],
        )
    );
  }
}

class TopScorersChartData {
  TopScorersChartData(this.name, this.pointsScored,this.color);

  final String name;
  final int pointsScored;
  final Color color;
}
