import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;

//TODO: REMOVE THIS FILE

class HomeVsAwayWinsChart extends StatefulWidget {
  const HomeVsAwayWinsChart({ super.key });

  @override
  State<HomeVsAwayWinsChart> createState() => _HomeVsAwayWinsChart();
}

class _HomeVsAwayWinsChart extends State<HomeVsAwayWinsChart> {

  late TooltipBehavior _tooltipBehavior;
  late List<_ChartData> data;

  @override
  void initState(){
    _tooltipBehavior = TooltipBehavior(enable: true);
    data = [
      _ChartData('HOME TEAM', 18,constants.BLUE),
      _ChartData('AWAY TEAM', 15,constants.RED),
    ];
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
                primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10,title: AxisTitle(text:"#Wins",textStyle: TextStyle(fontSize: 13,fontWeight: FontWeight.w300))),
                tooltipBehavior: _tooltipBehavior,

                series: <ChartSeries<_ChartData, String>>[
                  ColumnSeries<_ChartData, String>(
                      dataSource: data,
                      xValueMapper: (_ChartData data, _) => data.team,
                      yValueMapper: (_ChartData data, _) => data.wins,
                      name: 'Number of wins',
                      pointColorMapper: (_ChartData data, _) => data.color,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5))
                  ),
                ]
            ),
          ),
          const Text(
              "This chart represents how being the Home Team may influence the result of the match.",
              style:TextStyle(fontWeight: FontWeight.normal,fontSize: 14,height: 1.2)
          ),
        ],
      )
    );
  }
}

class _ChartData {
  _ChartData(this.team, this.wins,this.color);

  final String team;
  final double wins;
  final Color color;
}