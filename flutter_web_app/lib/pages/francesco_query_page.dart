import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter_web_app/classes/date_integer_chart_data.dart';
import 'package:flutter_web_app/classes/string_integer_chart_data.dart';
import 'package:flutter_web_app/page_blocks/cartesian_integer_integer_chart_block.dart';
import 'package:flutter_web_app/page_blocks/paragraph_block.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;
import 'package:flutter_web_app/page_blocks/table_block.dart';
import 'package:format/format.dart';
import '../page_blocks/query_code_block.dart';
import '../page_blocks/histogram_date_integer_chart_block.dart';

class FrancescoQueryPage extends StatefulWidget{
  final scrollCallback;

  const FrancescoQueryPage({Key? key,this.scrollCallback}) : super(key: key);

  @override
  State<FrancescoQueryPage> createState() => _FrancescoQueryPage();
}

class _FrancescoQueryPage extends State<FrancescoQueryPage> {
  //DATA MEMBERS
  final ScrollController _scrollController = ScrollController();
  late final _scrollCallback;
  List<DateIntegerChartData> _resultQueryData1 = [];
  List<List<String>> _resultQueryData2 = [];
  List<List<StringIntegerChartData>> _resultQueryData3 = [];
  String _resultQueryData4 = "";

  //CALLED AT THE BEGINNING
  @override
  void initState() {
    _scrollCallback = widget.scrollCallback;
    _scrollController.addListener(() {
      if(_scrollController.position.pixels <= constants.SCROLLCONTROLLER_POSITION_PIXELS)
        _scrollCallback(constants.TOP);
      else if(_scrollController.position.pixels> constants.SCROLLCONTROLLER_POSITION_PIXELS)
        _scrollCallback(constants.BOTTOM);
    });
    super.initState();
  }

  //CALLED AT THE END
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  //HERE YOU SPECIFY THE LAYOUT
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
        child: Padding(
          padding: constants.PAGE_PADDING_PADDING_STYLE,
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              constants.SIZED_BOX_BLOCK_STYLE,
              //QUERY 1
              const ParagraphBlock(
                title: "LeBron James points during 2017-2018 season\n",
                titleStyle: constants.BLOCK_PAGES_TITLE_STYLE_PARAGRAPH,
                content: ["This query finds the points scored by LeBron James during the 2017-2018 season.\n"],
                contentStyle: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH
              ),
              Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
                child: QueryCodeBlock(callbackQueryResult: callbackQueryResult1,editable: false,startQuery: constants.FRANCESCO_QUERY_1)
              ),
              Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
                child:SizedBox(
                    width: double.infinity,height: 400,
                    child:HistogramDateIntegerChartBlock(
                      chartData: _resultQueryData1,
                      descriptionXAxis: "Dates of the games played",
                      descriptionYAxis: "#Points",
                      nameTooltip: "Points Scored",
                      minValueY: 0,
                      maxValueY: 80,
                      intervalValueY: 1,
                    ))
              ),
              //QUERY 2
              const ParagraphBlock(
                title: "Chicago Bulls team during the 2006-2007 season with the corresponding time played\n",
                titleStyle: constants.BLOCK_PAGES_TITLE_STYLE_PARAGRAPH,
                content: ["This query finds who played for the Chicago Bulls team during the 2006-2007 season and how much time each player played.\n"],
                contentStyle: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH
              ),
              Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
                child: QueryCodeBlock(callbackQueryResult: callbackQueryResult2,editable: false,startQuery: constants.FRANCESCO_QUERY_2),
              ),
              Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
                child:SizedBox(width: double.infinity,height: 400, child:TableBlock(tableData: _resultQueryData2, tableCols: constants.TABLE_COLUMNS_NAME_QUERY2_FRANCESCO))
              ),
              //QUERY 3
              const ParagraphBlock(
                  title: "3 Points Attempts VS 2 Points Attempts scored during seasons\n",
                  titleStyle: constants.BLOCK_PAGES_TITLE_STYLE_PARAGRAPH,
                  content: ["This query finds how many 3 points attempts and how many 2 points attempts were scored during all the seasons.\n"],
                  contentStyle: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH
              ),
              Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
                child: QueryCodeBlock(callbackQueryResult: callbackQueryResult3,editable: false,startQuery: constants.FRANCESCO_QUERY_3),
              ),
              Padding(
                  padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
                  child:SizedBox(
                      width: double.infinity,height: 400,
                      child:CartesianIntegerIntegerChartBlock(
                        chartData: _resultQueryData3,
                        descriptionXAxis: "Seasons",
                        descriptionYAxis: "#Attempts",
                        nameTooltips: ["#Attempts 2 Points",'#Attempts 3 Points'],
                        minValueY: 0,
                        maxValueY: 100000,
                        intervalValueY: 5000,
                      ))
              ),
              //QUERY 4
              const ParagraphBlock(
                  title: "Games with the same score\n",
                  titleStyle: constants.BLOCK_PAGES_TITLE_STYLE_PARAGRAPH,
                  content: ["Are there any games that have the same exact score?\n"],
                  contentStyle: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH
              ),
              Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
                child: QueryCodeBlock(callbackQueryResult: callbackQueryResult4,editable: false,startQuery: constants.FRANCESCO_QUERY_4),
              ),
              Container(
                alignment: Alignment.center,
                child: Padding(
                    padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
                    child: Text(_resultQueryData4,  style: constants.BLOCK_PAGES_TITLE_STYLE_PARAGRAPH),
                  )
              )
            ]
          )
        )
    );
  }
  //CALLBACKS
  callbackQueryResult1(var response){
    List<DateIntegerChartData> list = [];

    int i=0;
    //Parse the response
    for(var data in response['results']['bindings']){
      List<String> datePieces = data['matchDate']['value'].split('-');
      DateTime date = DateTime(int.parse(datePieces.elementAt(0)),
          int.parse(datePieces.elementAt(1)),
          int.parse(datePieces.elementAt(2)));

      int points = int.parse(data['pts']['value']);
      if(i%2==0){
        list.add(DateIntegerChartData(date,points,constants.BLUE));
      }else{
        list.add(DateIntegerChartData(date,points,constants.RED));
      }
      i++;
    }

    //Remove Previous Content
    _resultQueryData1.clear();

    //Add new content
    setState(() {
      _resultQueryData1.addAll(list);
    });
  }

  callbackQueryResult2(var response){
    List<List<String>> list = [];

    //Parse the response
    for(var data in response['results']['bindings']){
      String playerName = data['name']['value'];
      int minutesPlayed = int.parse(data['totalMinutesPlayer']['value']);
      int secondsPlayed = int.parse(data['totalSecondsPlayer']['value']);

      //Convert into hours-minutes-seconds
      List<String> parts = Duration(minutes: minutesPlayed,seconds: secondsPlayed).toString().split(':');

      String timePlayed = format("Hours : {} Minutes : {} Seconds : {}",parts[0],parts[1],parts[2].substring(0,2));

      list.add([playerName,timePlayed]);
    }

    //Remove Previous Content
    _resultQueryData2.clear();

    //Add new content
    setState(() {
      _resultQueryData2.addAll(list);
    });
  }

  callbackQueryResult3(var response){
    List<List<StringIntegerChartData>> list = [];

    List<StringIntegerChartData> twoPointsAttemptsList = [];
    List<StringIntegerChartData> threePointsAttemptsList = [];

    //Parse the response
    for(var data in response['results']['bindings']){

      String season = data['season']['value'];
      int twoPointsAttempts = int.parse(data['number2PointsMade']['value']);
      int threePointsAttempts = int.parse(data['number3PointsMade']['value']);



      twoPointsAttemptsList.add(StringIntegerChartData(season, twoPointsAttempts,constants.BLUE));
      threePointsAttemptsList.add(StringIntegerChartData(season, threePointsAttempts,constants.RED));
    }
    list.add(twoPointsAttemptsList);
    list.add(threePointsAttemptsList);


    //Remove Previous Content
    _resultQueryData3.clear();

    //Add new content
    setState(() {
      _resultQueryData3.addAll(list);
    });
  }

  callbackQueryResult4(var response){
    //Parse response and substitute with new content
    setState(() {
      _resultQueryData4 = response['boolean'].toString().toUpperCase();
    });
  }

}