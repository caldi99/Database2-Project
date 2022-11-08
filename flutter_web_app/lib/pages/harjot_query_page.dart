import 'package:flutter/material.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;
import 'package:flutter_web_app/page_blocks/paragraph_block.dart';
import 'package:flutter_web_app/page_blocks/query_code_block.dart';
import 'package:flutter_web_app/page_blocks/table_block.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HarjotQueryPage extends StatefulWidget {
  final scrollCallback;

  const HarjotQueryPage({Key? key, this.scrollCallback}) : super(key: key);

  @override
  State<HarjotQueryPage> createState() => _HarjotQueryPage();
}

class _HarjotQueryPage extends State<HarjotQueryPage> {
  //DATA MEMBERS
  final ScrollController _scrollController = ScrollController();
  late final _scrollCallback;

  List<ChartData> _resultQueryData1 = [];
  List<List<String>> _resultQueryData2 = [];

  //CALLED AT THE BEGINNING
  @override
  void initState() {
    _scrollCallback = widget.scrollCallback;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels <=
          constants.SCROLLCONTROLLER_POSITION_PIXELS)
        _scrollCallback(constants.TOP);
      else if (_scrollController.position.pixels >
          constants.SCROLLCONTROLLER_POSITION_PIXELS)
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              constants.SIZED_BOX_BLOCK,
              const ParagraphBlock(
                  title: "HomeTeam vs AwayTeam wins \n",
                  titleStyle: constants.BLOCK_PAGES_TITLE_STYLE_PARAGRAPH,
                  content: [
                    "This query allows us to find how much the home ground affects the teams.\n"
                  ],
                  contentStyle: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH),
              Padding(
                  padding: constants.BLOCK_PAGES_PADDING_PADDING_PROPRIETY,
                  child: QueryCodeBlock(
                      callbackQueryResult: callbackQueryResult1,
                      editable: false,
                      startQuery: constants.HARJOT_QUERY_1)),
              Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_PROPRIETY,
                child: SfCircularChart(
                  title: ChartTitle(text: "Home/Away wins"),
                  legend: Legend(
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap),
                  series: <CircularSeries>[
                    PieSeries<ChartData, String>(
                        dataSource: _resultQueryData1,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        enableTooltip: true)
                  ],
                ),
              ),
              const ParagraphBlock(
                  title:
                      "Teams with most international NBA Players (excluding USA)\n",
                  titleStyle: constants.BLOCK_PAGES_TITLE_STYLE_PARAGRAPH,
                  content: [
                    "With this query you get the top team with in which most international players has played.\n"
                  ],
                  contentStyle: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH),
              Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_PROPRIETY,
                child: QueryCodeBlock(
                    callbackQueryResult: callbackQueryResult2,
                    editable: false,
                    startQuery: constants.HARJOT_QUERY_2),
              ),
              Padding(
                  padding: constants.BLOCK_PAGES_PADDING_PADDING_PROPRIETY,
                  child: SizedBox(
                      width: double.infinity,
                      height: 400,
                      child: TableBlock(
                          tableData: _resultQueryData2,
                          tableCols:
                              constants.TABLE_COLUMNS_NAME_QUERY2_HARJOT)))
            ],
          ),
        ));
  }

  //CALLBACKS
  callbackQueryResult1(var response) {
    List<ChartData> list = [];

    //Parse the response
    for (var data in response['results']['bindings']) {
      String winHome =
          data['winHome']['value'] == "0" ? "AwayWins" : "HomeWins";
      int numberOfGames = int.parse(data['numberOfGames']['value']);
      list.add(ChartData(winHome, numberOfGames));
    }

    //Remove Previous Content
    _resultQueryData1.clear();

    //Add new content
    setState(() {
      _resultQueryData1.addAll(list);
    });
  }

  callbackQueryResult2(var response) {
    List<List<String>> temp = [];

    //Parse the response
    for (var data in response['results']['bindings']) {
      String clubName = data['clubName']['value'];
      String internationalPlayers = data['internationalPlayers']['value'];
      temp.add([clubName, internationalPlayers]);
    }

    //Remove Previous Content
    _resultQueryData2.clear();

    //Add new content
    setState(() {
      _resultQueryData2.addAll(temp);
    });
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final int y;
}

/*class TableData {
  TableData(this.clubName, this.internationalPlayers);
  final String clubName;
  final int internationalPlayers;
}*/
