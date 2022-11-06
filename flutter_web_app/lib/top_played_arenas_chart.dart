import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;

class TopArenasChart extends StatefulWidget {
  const TopArenasChart({ super.key, this.data });
  final data;

  @override
  State<TopArenasChart> createState() => _TopArenasChart();
}

class _TopArenasChart extends State<TopArenasChart> {

  late TooltipBehavior _tooltipBehavior;
  late final List<TopArenasChartData> data;


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
                  primaryYAxis: NumericAxis(minimum: 0, maximum: 1900, interval: 100,title: AxisTitle(text:"#Matches",textStyle: TextStyle(fontSize: 13,fontWeight: FontWeight.w300))),
                  tooltipBehavior: _tooltipBehavior,

                  series: <ChartSeries<TopArenasChartData, String>>[
                    ColumnSeries<TopArenasChartData, String>(
                        dataSource: data,
                        xValueMapper: (TopArenasChartData data, _) => data.name,
                        yValueMapper: (TopArenasChartData data, _) => data.timesPlayed                                                                                ,
                        name: 'Matches played',
                        pointColorMapper: (TopArenasChartData data, _) => data.color,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5))
                    ),
                  ]
              ),
            ),
            const Text(
                "The Arenas sorted by the number of matches played",
                style:TextStyle(fontWeight: FontWeight.normal,fontSize: 14,height: 1.2)
            ),
          ],
        )
    );
  }
}

class TopArenasChartData {
  TopArenasChartData(this.name,this.timesPlayed, this.capacity,this.color);

  final String name;
  final int timesPlayed;
  final int capacity;
  final Color color;
}
