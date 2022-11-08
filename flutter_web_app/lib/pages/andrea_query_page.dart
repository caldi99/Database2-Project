import 'package:flutter/material.dart';
import 'package:flutter_web_app/classes/string_integer_chart_data.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;
import 'package:flutter_web_app/page_blocks/histogram_string_integer_chart_block.dart';
import 'package:flutter_web_app/page_blocks/query_code_block.dart';
import 'package:flutter_web_app/page_blocks/paragraph_block.dart';

class AndreaQueryPage extends StatefulWidget {
  final scrollCallback;

  const AndreaQueryPage({Key? key,this.scrollCallback}) : super(key: key);

  @override
  State<AndreaQueryPage> createState() => _AndreaQueryPage();
}

class _AndreaQueryPage extends State<AndreaQueryPage> {
  //DATA MEMBERS
  final ScrollController _scrollController=ScrollController();
  late final _scrollCallback;
  List<StringIntegerChartData> dataTopScorers=[];
  List<StringIntegerChartData> dataTopArenas=[];

  //CALLED AT THE BEGINNING
  @override
  void initState() {
    _scrollCallback=widget.scrollCallback;
    _scrollController.addListener(() {
      if(_scrollController.position.pixels <= constants.SCROLLCONTROLLER_POSITION_PIXELS)
        _scrollCallback(constants.TOP);
      else if(_scrollController.position.pixels > constants.SCROLLCONTROLLER_POSITION_PIXELS)
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
                title: "Top Scorers\n",
                titleStyle: constants.BLOCK_PAGES_TITLE_STYLE_PARAGRAPH,
                content: ["This query aims at finding the top 10 scorers in the NBA championship.\n",
                  "The query result will consists in the name of the players and the corresponding amount of points scored sorted in descending order.\n"],
                contentStyle: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH
            ),
            Padding(
              padding: constants.BLOCK_PAGES_PADDING_PADDING_PROPRIETY,
              child:QueryCodeBlock(callbackQueryResult:callbackQueryResultTopScorers,editable: false,startQuery: constants.ANDREA_QUERY_1)
            ),
            Padding(
              padding: constants.BLOCK_PAGES_PADDING_PADDING_PROPRIETY,
              child:SizedBox(width: double.infinity,height: 400,
                  child : HistogramStringIntegerChartBlock(
                    chartData: dataTopScorers,
                    nameTooltip: "Scored Points",
                    intervalValueY: 5000,
                    maxValueY: 45000,
                    minValueY: 0,
                    descriptionYAxis: "#Points",
                    descriptionXAxis: "The Top 10 scorers with their corresponding number of scored points",
                )
              )
            ),
            const ParagraphBlock(
                title: "Arenas with most played matches\n",
                titleStyle: constants.BLOCK_PAGES_TITLE_STYLE_PARAGRAPH,
                content: ["This query aims at retrieving in ascending order the Arenas with the highest numbers of played matches.\n",
                  "The query result will consists in the name of the arenas and the corresponding amount of played matches. We also show their capacities.\n"],
                contentStyle: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH
            ),
            Padding(
              padding: constants.BLOCK_PAGES_PADDING_PADDING_PROPRIETY,
              child:QueryCodeBlock(callbackQueryResult:callbackQueryResultTopArenas,editable: false,startQuery: constants.ANDREA_QUERY_2)
            ),
            Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_PROPRIETY,
                child:SizedBox(width: double.infinity,height: 400,
                    child : HistogramStringIntegerChartBlock(
                      chartData: dataTopArenas,
                      nameTooltip: "Matches played",
                      intervalValueY: 100,
                      maxValueY: 1900,
                      minValueY: 0,
                      descriptionYAxis: "#Matches",
                      descriptionXAxis: "The Arenas sorted by the number of matches played",
                    )
                )
            ),
          ],
        ),
      )
    );
  }

  //CALLBACKS
  callbackQueryResultTopArenas(var res){
    List<StringIntegerChartData> temp=[];

    //PARSING
    for (var result  in res['results']['bindings']){
      String name=result['name']['value'];
      int numberOfGames=double.parse(result['numberOfGames']['value']) as int;
      temp.add(StringIntegerChartData(name,numberOfGames));
    }

    //REMOVE PREVIOUS DATA
    dataTopScorers.clear();

    //SET NEW DATA
    setState(() {
      dataTopArenas.addAll(temp);
    });
  }

  callbackQueryResultTopScorers(var res){
    List<StringIntegerChartData> temp = [];

    //PARSING
    for (var result  in res['results']['bindings']){
      String name=result['name']['value'];
      int pointsScored=int.parse(result['points']['value']);
      temp.add(StringIntegerChartData(name,pointsScored));
    }

    //REMOVE PREVIOUS DATA
    dataTopScorers.clear();

    //SET NEW DATA
    setState(() {
      dataTopScorers.addAll(temp);
    });

  }
}