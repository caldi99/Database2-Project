import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_web_app/home_vs_away_wins_chart.dart';
import 'package:flutter_web_app/html_graph_visualizer.dart';
import 'package:flutter_web_app/main_page.dart';
import 'package:flutter_web_app/query_handler.dart';
import 'package:flutter_web_app/query_input_field.dart';
import 'package:flutter_web_app/query_page_1.dart';
import 'package:flutter_web_app/query_page_2.dart';
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
  List<bool> scrollAtTop=[true,true,true];


  /*List<List<String>> elementsQueried=[];
  List<String> columns=[];*/

  int indexShowingPage=0;

  @override
  void initState() {
    super.initState();
    _animationController =  AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    sizeAnimation = Tween<double>(begin: maxHeight, end: minHeight).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut
    ));
    _animationController.addListener(() {
      setState(() {
        sizeAnimation;
      });
    });
  }

  scrollCallback(String arg){
    if(arg.compareTo("TOP")==0){
      if(!scrollAtTop[indexShowingPage]) {
        _animationController.reverse();
        scrollAtTop[indexShowingPage]=true;
      }
    }
    else if(arg.compareTo("BOTTOM")==0){
      if(scrollAtTop[indexShowingPage]) {
        _animationController.forward();
        scrollAtTop[indexShowingPage]=false;
      }
    }
  }

  _forceScrollCallback(String arg){
    if(arg.compareTo("TOP")==0){
        _animationController.reverse();
    }
    else if(arg.compareTo("BOTTOM")==0){
        _animationController.forward();
    }

  }

  @override
  void dispose() {
    _animationController.dispose();
    //_scrollController.dispose();
    super.dispose();
  }



  void goToPage(int page){
    setState(() {
      indexShowingPage=page;
    });
    if(!scrollAtTop[indexShowingPage]){
      _forceScrollCallback("BOTTOM");
    }
    else if(scrollAtTop[indexShowingPage]){
      _forceScrollCallback("TOP");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body:Stack(
        children: [
          Positioned.fill(
            top:minHeight-roundBorderSize,
              /*children: [
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
                      SizedBox(
                          height: 400,
                          // A couple of charts
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

                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: QueryParagraph(),
                ),

                Padding(
                    padding: EdgeInsets.only(top:20,bottom: 20,left: 100,right: 100),
                    child:QueryInput(callbackQueryResult:callbackQueryResult)
                ),

                (columns.length>0)?Padding(
                  padding: EdgeInsets.only(left: 100,right: 100),
                  child:Container(
                      padding: EdgeInsets.only(left: 20,right: 20),
                      height: 100,
                      decoration: BoxDecoration(
                        color: constants.BLUE,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20),),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 3,
                            blurRadius: 8,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child:Row(

                        children: List<Widget>.generate(columns.length, (i) {
                          return Expanded(
                            flex: 1,
                            child:Text(columns[i],style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),

                          );
                        }
                        ),
                      )
                  ),
                ):SizedBox(),
                (columns.length>0)?Padding(
                  padding: EdgeInsets.only(left: 100,right: 100,bottom: 50),
                  child:
                  Container(
                    height: 600,
                    padding: EdgeInsets.only(left: 20,right: 20),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20),),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child:ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                          color: Colors.grey,

                        ),
                        itemCount: elementsQueried.length,
                        itemBuilder: (BuildContext context, int index) {
                          if(index==0){
                            return Container(
                                height: 35,
                                padding: EdgeInsets.only(top:5),
                                child:Row(
                                  children: List<Widget>.generate(elementsQueried[0].length, (i) {
                                    return Expanded(
                                      flex: 1,
                                      child:Text(elementsQueried[index][i],textAlign: TextAlign.center,),
                                    );
                                  }),
                                )
                            );
                          }
                          return SizedBox(
                            height: 30,
                              child:Row(
                                children: List<Widget>.generate(elementsQueried[0].length, (i) {
                                  return Expanded(
                                    flex: 1,
                                    child:Text(elementsQueried[index][i],textAlign: TextAlign.center,),
                                  );
                                }),
                              )
                          );
                        }),
                  ),
                ):SizedBox(),
              ],*/
              child:IndexedStack(
                index: indexShowingPage,
                children: [
                  MainPage(scrollCallback: scrollCallback,),
                  QueryPage1(scrollCallback: scrollCallback,),
                  QueryPage2(scrollCallback: scrollCallback,)
                ],

              )

            ),
          //),

          Positioned(
            top:0,
            right: 0,
            left: 0,
            child: CustomHeader( sizeAnimation: sizeAnimation,
              goToPage: goToPage,

            ),
          ),
        ],
      ),
    );
  }
}
/*
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
}*/
