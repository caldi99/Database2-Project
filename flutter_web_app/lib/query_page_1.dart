import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;
import 'package:flutter_web_app/input_query_code_field.dart';
import 'package:flutter_web_app/paragraphs.dart';
import 'package:flutter_web_app/top_played_arenas_chart.dart';
import 'package:flutter_web_app/top_scorers_chart.dart';
class QueryPage1 extends StatefulWidget {
  const QueryPage1({Key? key,this.scrollCallback}) : super(key: key);
  final scrollCallback;
  @override
  State<QueryPage1> createState() => _QueryPage1();
}

class _QueryPage1 extends State<QueryPage1> {
  final ScrollController _scrollController=ScrollController();
  late final scrollCallback;
  final String query1='''PREFIX base: <https://www.dei.unipd.it/Database2/CPS-NBA/>
SELECT ?name ( SUM(?pts) AS ?points ) WHERE {
    ?person base:wasPlayer ?player ;
        base:name ?name .
    ?player base:appearsIn ?appearance .
    ?appearance base:pts ?pts .
} GROUP BY (?name)
ORDER BY DESC (?points)
LIMIT 10''';

  final String query2='''PREFIX base: <https://www.dei.unipd.it/Database2/CPS-NBA/>
SELECT ?name ?capacity ?numberOfGames WHERE{
    ?arena base:name ?name ;
        base:capacity ?capacity .
    {
        SELECT ?arena ( COUNT(?game) AS ?numberOfGames ) WHERE {
              ?game base:hasHomeClub ?club .
              ?club base:hasStadium ?arena .   
        } GROUP BY ?arena
    }
} ORDER BY DESC (?numberOfGames)''';

  List<TopScorersChartData> dataTopScorers=[];
  List<TopArenasChartData> dataTopArenas=[];


  //CALLED AT THE BEGINNING
  @override
  void initState() {

    scrollCallback=widget.scrollCallback;
    _scrollController.addListener(() {
      if(_scrollController.position.pixels<=150){
        scrollCallback("TOP");
      }
      else if(_scrollController.position.pixels>150){
        scrollCallback("BOTTOM");
      }
    });

    super.initState();
  }

  //CALLED AT THE END
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  callbackQueryResultTopScorers(var res){
    //print(res);
    List<TopScorersChartData> temp=[];
    for (var result  in res['results']['bindings']){
      String name=result['name']['value'];
      int pointsScored=int.parse(result['points']['value']);
      Color color=Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
      temp.add(TopScorersChartData(name, pointsScored, color));
    }
    dataTopScorers.clear();
    setState(() {
      dataTopScorers.addAll(temp);
    });

  }

  callbackQueryResultTopArenas(var res){
    print(res);
    List<TopArenasChartData> temp=[];
    for (var result  in res['results']['bindings']){
      String name=result['name']['value'];
      int capacity=double.parse(result['capacity']['value']) as int;
      int numberOfGames=double.parse(result['numberOfGames']['value']) as int;
      Color color=Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
      temp.add(TopArenasChartData(name,numberOfGames, capacity, color));
    }
    dataTopScorers.clear();
    setState(() {
      dataTopArenas.addAll(temp);
    });

  }


  //HERE YOU SPECIFY THE LAYOUT
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: EdgeInsets.only(left: 20,right: 20),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 150,
            ),
            QueryPage1FirstQueryParagraph(),
            Padding(
              padding: EdgeInsets.only(left: 150,right: 150,top: 20,bottom: 20),
              child:QueryInputCode(callbackQueryResult:callbackQueryResultTopScorers,editable: false,startQuery: query1,),
            ),
            Padding(
              padding: EdgeInsets.only(left: 150,right: 150,top: 20,bottom: 20),
              child:SizedBox(width: double.infinity,height: 400, child:TopScorersChart(data: dataTopScorers,),)
            ),
            QueryPage1SecondQueryParagraph(),
            Padding(
              padding: EdgeInsets.only(left: 150,right: 150,top: 20,bottom: 20),
              child:QueryInputCode(callbackQueryResult:callbackQueryResultTopArenas,editable: false,startQuery: query2,),
            ),
            Padding(
                padding: EdgeInsets.only(left: 150,right: 150,top: 20,bottom: 20),
                child:SizedBox(width: double.infinity,height: 400, child:TopArenasChart(data: dataTopArenas,),)
            ),

          ],
        ),

      )


    );
  }
}