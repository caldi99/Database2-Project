import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_web_app/home_vs_away_wins_chart.dart';
import 'package:flutter_web_app/html_graph_visualizer.dart';
import 'package:flutter_web_app/main_page.dart';
import 'package:flutter_web_app/query_handler.dart';
import 'package:flutter_web_app/query_input_field.dart';
import 'package:flutter_web_app/query_page_1.dart';
import 'package:flutter_web_app/query_page_2.dart';
import 'package:flutter_web_app/query_page_3.dart';
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
  List<bool> scrollAtTop=[true,true,true,true];


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
              child:IndexedStack(
                index: indexShowingPage,
                children: [
                  MainPage(scrollCallback: scrollCallback,),
                  QueryPage1(scrollCallback: scrollCallback,),
                  QueryPage2(scrollCallback: scrollCallback,),
                  QueryPage3(scrollCallback: scrollCallback,)
                ],
              )
            ),

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
