import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_web_app/graph_handler.dart';
import 'package:flutter_web_app/graph_visualizer.dart';
import 'package:flutter_web_app/home_vs_away_wins_chart.dart';
import 'package:flutter_web_app/html_graph_visualizer.dart';
import 'package:flutter_web_app/query_handler.dart';
import 'package:flutter_web_app/query_input_field.dart';
import 'package:flutter_web_app/test_rich_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_web_app/constants.dart' as constants;
import 'package:http/http.dart' as http;
import 'package:flutter_web_app/header_style.dart';
import 'package:flutter_web_app/paragraphs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final maxHeight=200.0;
  final minHeight=80.0;
  final roundBorderSize=40.0;
  late AnimationController _animationController;
  late Animation sizeAnimation;
  final _scrollController = ScrollController();
  bool scrollTop=true;
  late SvgPicture picture;

  @override
  void initState() {
    super.initState();
    _animationController =  AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    sizeAnimation = Tween<double>(begin: maxHeight, end: minHeight).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut
    ));
    _animationController.addListener(() { setState(() {
      sizeAnimation;

    });});
    //picture= GraphVisualizer.httpRequestGraphDb();

    // Setting up the scroll listener
    _scrollController.addListener(() {
      print("SCROLL");
      if(_scrollController.position.pixels<=_scrollController.position.maxScrollExtent/10 && !scrollTop){
        _animationController.reverse();
        scrollTop=true;
      }
      else if(_scrollController.position.pixels>_scrollController.position.maxScrollExtent/10 && scrollTop){
        _animationController.forward();
        scrollTop=false;
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body:Stack(
        children: [
          Positioned.fill(
            top:minHeight-roundBorderSize,
            child:ListView(

              controller: _scrollController,
              scrollDirection: Axis.vertical,
              children: [
                const SizedBox(
                  height: 200,
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TitleAndDescriptionParagraph(),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: GraphParagraph(),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: GraphIFrame(),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: ChartParagraph(),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      //HomeVsAwayWinsChart()
                      SizedBox(
                          height: 400,

                          child:Row(



                            children: const [
                              Expanded(
                                flex: 3,
                                child:SizedBox(),

                              ),
                              Expanded(
                                flex: 12,
                                child:HomeVsAwayWinsChart(),

                              ),
                              Expanded(
                                flex: 3,
                                child:SizedBox(),

                              ),
                              Expanded(
                                flex:12,
                                child:HomeVsAwayWinsChart(),

                              ),
                              Expanded(
                                flex: 3,
                                child:SizedBox(),

                              ),

                            ],
                          )
                      ),
                    ],
                  ),
                ),



                /*SizedBox(
                  height: 500,
                  //color: Colors.amber[500],
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:Row(

                      children: [
                        Expanded(
                          child:
                          SfCartesianChart(
                            // Initialize category axis
                              primaryXAxis: CategoryAxis(),

                              series: <LineSeries<SalesData, String>>[
                                LineSeries<SalesData, String>(
                                  // Bind data source
                                    dataSource:  <SalesData>[
                                      SalesData('Jan', 35),
                                      SalesData('Feb', 28),
                                      SalesData('Mar', 34),
                                      SalesData('Apr', 32),
                                      SalesData('May', 40)
                                    ],
                                    xValueMapper: (SalesData sales, _) => sales.year,
                                    yValueMapper: (SalesData sales, _) => sales.sales
                                )
                              ]
                          ),
                        ),
                        Expanded(child:SfCartesianChart(
                          // Initialize category axis
                            primaryXAxis: CategoryAxis(),

                            series: <LineSeries<SalesData, String>>[
                              LineSeries<SalesData, String>(
                                // Bind data source
                                  dataSource:  <SalesData>[
                                    SalesData('Jan', 35),
                                    SalesData('Feb', 28),
                                    SalesData('Mar', 34),
                                    SalesData('Apr', 32),
                                    SalesData('May', 40)
                                  ],
                                  xValueMapper: (SalesData sales, _) => sales.year,
                                  yValueMapper: (SalesData sales, _) => sales.sales
                              )
                            ]
                        )
                        )
                      ],
                    ),
                  ),
                ),
*/
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: QueryParagraph(),
                ),

                const Padding(
                    padding: EdgeInsets.all(20.0),
                    child:QueryInput()
                ),
                /*Container(
                  height: 500,
                  color: Colors.amber[100],
                  child: const Center(child: Text('Entry C')),
                ),*/
                /*ElevatedButton(
                  child: Text("ciao"),
                  onPressed: ()=>QueryHandler.httpRequestGraphDb("",true,true),
                ),
                ElevatedButton(
                  child: Text("ciao2"),
                  onPressed: ()=>GraphVisualizer.httpRequestGraphDb(),
                )*/
              ],
            ),
          ),

          Positioned(
            top:0,
            right: 0,
            left: 0,
            child: CustomHeader( sizeAnimation: sizeAnimation),

            //child: ClipPath(
            //clipper: BackgroundWaveClipper(),
          ),

        ],
      ),
    );
  }
}

class BackgroundWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    print(size);
    var path = Path();

    const minSize = 50.0;

    // when h = max = 280
    // h = 280, p1 = 210, p1Diff = 70
    // when h = min = 140
    // h = 140, p1 = 140, p1Diff = 0
    final p1Diff = ((minSize - size.height) * 0.5).truncate().abs();
    path.lineTo(0.0, size.height - p1Diff);

    final controlPoint = Offset(size.width * 0.1, size.height);


    final endPoint = Offset(size.width, minSize);

    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(BackgroundWaveClipper oldClipper) => oldClipper != this;
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
