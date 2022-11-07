import 'package:flutter/cupertino.dart';
import 'package:flutter_web_app/classes/date_number_chart_data.dart';
import 'package:flutter_web_app/page_blocks/paragraph_block.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;
import 'package:flutter_web_app/page_blocks/table_block.dart';
import 'package:format/format.dart';
import '../page_blocks/query_code_block.dart';
import '../page_blocks/histogram_date_number_chart_block.dart';

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
  List<DateNumberChartData> _resultQueryData1 = [];
  List<List<String>> _resultQueryData2 = [];

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
          padding: constants.PAGE_PADDING_PADDING_PROPRIETY,
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              constants.SIZED_BOX_BLOCK,
              const ParagraphBlock(
                title: "LeBron James points during 2017-2018 season\n",
                titleStyle: constants.BLOCK_PAGES_TITLE_STYLE_PARAGRAPH,
                content: ["This query finds the points scored by LeBron James during the 2017-2018 season.\n"],
                contentStyle: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH
              ),
              Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_PROPRIETY,
                child: QueryCodeBlock(callbackQueryResult: callbackQueryResult1,editable: false,startQuery: constants.FRANCESCO_QUERY_1)
              ),
              Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_PROPRIETY,
                child:SizedBox(width: double.infinity,height: 400, child:HistogramDateNumberChartBlock(chartData: _resultQueryData1))
              ),
              const ParagraphBlock(
                title: "Chicago Bulls team during the 2006-2007 season with the corresponding time played\n",
                titleStyle: constants.BLOCK_PAGES_TITLE_STYLE_PARAGRAPH,
                content: ["This query finds who played for the Chicago Bulls team during the 2006-2007 season and how much time was played for each player.\n"],
                contentStyle: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH
              ),
              Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_PROPRIETY,
                child: QueryCodeBlock(callbackQueryResult: callbackQueryResult2,editable: false,startQuery: constants.FRANCESCO_QUERY_2),
              ),
              Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_PROPRIETY,
                child:SizedBox(width: double.infinity,height: 400, child:TableBlock(tableData: _resultQueryData2, tableCols: constants.TABLE_COLUMN_NAME_QUERY2_FRANCESCO))
              )
            ],
          ),
        )
    );
  }
  //CALLBACKS
  callbackQueryResult1(var response){
    List<DateNumberChartData> list = [];

    //Parse the response
    for(var data in response['results']['bindings']){
      List<String> datePieces = data['matchDate']['value'].split('-');
      DateTime date = DateTime(int.parse(datePieces.elementAt(0)),
          int.parse(datePieces.elementAt(1)),
          int.parse(datePieces.elementAt(2)));

      int points = int.parse(data['pts']['value']);

      list.add(DateNumberChartData(date, points));
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
}