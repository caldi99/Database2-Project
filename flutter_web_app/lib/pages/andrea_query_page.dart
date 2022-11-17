import 'package:flutter/material.dart';
import 'package:flutter_web_app/classes/string_integer_chart_data.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;
import 'package:flutter_web_app/page_blocks/histogram_string_integer_chart_block.dart';
import 'package:flutter_web_app/page_blocks/query_code_block.dart';
import 'package:flutter_web_app/page_blocks/paragraph_block.dart';
import 'package:flutter_web_app/page_blocks/table_block.dart';

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
  List<StringIntegerChartData> dataStandings=[];

  //TODO: create class with 2 fields for weight and height and map to 2 columns
  List<List<String>> dataHeightWeight=[];

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
        padding: constants.PAGE_PADDING_PADDING_STYLE,
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            constants.SIZED_BOX_BLOCK_STYLE,
            const ParagraphBlock(
                title: "Top Scorers\n",
                titleStyle: constants.BLOCK_PAGES_TITLE_STYLE_PARAGRAPH,
                content: ["This query aims at finding the top 10 scorers in the NBA championship.\n",
                  "The query result will consist in the name of the players and the corresponding amount of points scored sorted by descending order.\n"],
                contentStyle: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH
            ),
            Padding(
              padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
              child:QueryCodeBlock(callbackQueryResult:callbackQueryResultTopScorers,editable: false,startQuery: constants.ANDREA_QUERY_1)
            ),
            Padding(
              padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
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
                content: ["This query aims at retrieving in descending order the Arenas with the highest numbers of played matches.\n",
                  "The query result will consists in the name of the arenas and the corresponding amount of played matches. We also show their capacities.\n"],
                contentStyle: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH
            ),
            Padding(
              padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
              child:QueryCodeBlock(callbackQueryResult:callbackQueryResultTopArenas,editable: false,startQuery: constants.ANDREA_QUERY_2)
            ),
            Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
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
            const ParagraphBlock(
                title: "NBA rankings for the 2010-11 season\n",
                titleStyle: constants.BLOCK_PAGES_TITLE_STYLE_PARAGRAPH,
                content: ["This query aims at retrieving in descending order the NBA clubs based on their number of won matches in the season of 2010-2011.\n"],
                contentStyle: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH
            ),
            Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
                child:QueryCodeBlock(callbackQueryResult:callbackQueryResultStandings,editable: false,startQuery: constants.ANDREA_QUERY_3)
            ),
            Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
                child:SizedBox(width: double.infinity,height: 400,
                    child : HistogramStringIntegerChartBlock(
                      chartData: dataStandings,
                      nameTooltip: "Matches won",
                      intervalValueY: 5,
                      maxValueY: 100,
                      minValueY: 0,
                      descriptionYAxis: "#Matches",
                      descriptionXAxis: "The NBA rankings in the 2010-11 season",
                    )
                )
            ),
            const ParagraphBlock(
                title: "Average weight/height of the winner/loser team in the 2010-11 season\n",
                titleStyle: constants.BLOCK_PAGES_TITLE_STYLE_PARAGRAPH,
                content: ["This query aims at retrieving the average height and weight of the players of the club with the highest number of won matches and the club with the lowest number of won matches.\n",
                "In particular, we would like to see if height and weight may influence the performance of a team.\n"],
                contentStyle: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH
            ),
            Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
                child:QueryCodeBlock(callbackQueryResult:callbackQueryResultHeightWeight,editable: false,startQuery: constants.ANDREA_QUERY_4)
            ),
            Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
                child:SizedBox(
                    width: double.infinity,height: 400,
                    child:TableBlock(
                        tableData: dataHeightWeight,
                        tableCols: constants.TABLE_COLUMNS_NAME_QUERY4_ANDREA
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
    int i=0;
    for (var result  in res['results']['bindings']){
      String name=result['name']['value'];
      int numberOfGames=double.parse(result['numberOfGames']['value']) as int;
      if(i%2==0){
        temp.add(StringIntegerChartData(name,numberOfGames,constants.BLUE));
      }else{
        temp.add(StringIntegerChartData(name,numberOfGames,constants.RED));
      }
      i++;

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
    int i=0;
    for (var result  in res['results']['bindings']){
      String name=result['name']['value'];
      int pointsScored=int.parse(result['points']['value']);
      if(i%2==0){
        temp.add(StringIntegerChartData(name,pointsScored,constants.BLUE));
      }else{
        temp.add(StringIntegerChartData(name,pointsScored,constants.RED));
      }
      i++;
    }

    //REMOVE PREVIOUS DATA
    dataTopScorers.clear();

    //SET NEW DATA
    setState(() {
      dataTopScorers.addAll(temp);
    });

  }

  callbackQueryResultStandings(var res){
    List<StringIntegerChartData> temp = [];
    print(res);

    int i=0;
    //PARSING
    for (var result  in res['results']['bindings']){
      String name=result['nickname']['value'];
      int totalWins=int.parse(result['totalWins']['value']);
      if(i%2==0){
        temp.add(StringIntegerChartData(name,totalWins,constants.BLUE));
      }else{
        temp.add(StringIntegerChartData(name,totalWins,constants.RED));
      }
      i++;
    }

    //REMOVE PREVIOUS DATA
    dataStandings.clear();

    //SET NEW DATA
    setState(() {
      dataStandings.addAll(temp);
    });

  }

  callbackQueryResultHeightWeight(var res){
    List<List<String>> temp = [];

    //PARSING
    for (var result  in res['results']['bindings']){
      String name=result['nicknameTeam']['value'];
      int totalWins=int.parse(result['totalWins']['value']);
      double avgWeight=double.parse(result['weightAvg']['value']);
      double avgHeight=double.parse(result['heightAvg']['value']);
      temp.add([name,totalWins.toString(),avgWeight.toString(),avgHeight.toString()]);
    }

    //REMOVE PREVIOUS DATA
    dataHeightWeight.clear();

    //SET NEW DATA
    setState(() {
      dataHeightWeight.addAll(temp);
    });

  }
}