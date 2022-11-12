import 'package:flutter/material.dart';
import 'package:flutter_web_app/pages/main_page.dart';
import 'package:flutter_web_app/pages/andrea_query_page.dart';
import 'package:flutter_web_app/pages/harjot_query_page.dart';
import 'package:flutter_web_app/page_blocks/header_block.dart';
import 'package:flutter_web_app/pages/francesco_query_page.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPS-NBA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'CPS-NBA Home Page'),
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
  List<bool> scrollAtTop=[true,true,true,true];
  late final HeaderSize headerSize;

  int indexShowingPage=0;

  @override
  void initState() {
    super.initState();
    headerSize=HeaderSize(maxHeight);
  }

  scrollCallback(String arg){
    if(arg.compareTo(constants.TOP)==0){
      if(!scrollAtTop[indexShowingPage]) {
        setState(() {
          headerSize.size=maxHeight;
        });
        scrollAtTop[indexShowingPage]=true;
      }
    }
    else if(arg.compareTo(constants.BOTTOM)==0){
      if(scrollAtTop[indexShowingPage]) {
        setState(() {
          headerSize.size=minHeight;
        });
        scrollAtTop[indexShowingPage]=false;
      }
    }
  }

  _forceScrollCallback(String arg){
    if(arg.compareTo(constants.TOP)==0){
      setState(() {
        headerSize.size=maxHeight;
      });
    }
    else if(arg.compareTo(constants.BOTTOM)==0){
        setState(() {
          headerSize.size=minHeight;
        });
    }
  }

  void goToPage(int page){
    setState(() {
      indexShowingPage=page;
    });
    if(!scrollAtTop[indexShowingPage]){
      _forceScrollCallback(constants.BOTTOM);
    }
    else if(scrollAtTop[indexShowingPage]){
      _forceScrollCallback(constants.TOP);
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
                  AndreaQueryPage(scrollCallback: scrollCallback,),
                  FrancescoQueryPage(scrollCallback: scrollCallback,),
                  HarjotQueryPage(scrollCallback: scrollCallback,)
                ],
              )
            ),
          Positioned(
            top:0,
            right: 0,
            left: 0,
            child: HeaderBlock( sizeAnimation: headerSize,
              goToPage: goToPage,
            ),
          ),
        ],
      ),
    );
  }
}
