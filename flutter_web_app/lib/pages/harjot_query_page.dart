import 'package:flutter/material.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;
import 'package:flutter_web_app/page_blocks/paragraph_block.dart';
import 'package:flutter_web_app/page_blocks/pie_chart_block.dart';
import 'package:flutter_web_app/page_blocks/query_code_block.dart';
import 'package:flutter_web_app/page_blocks/table_block.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../classes/string_integer_chart_data.dart';

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

  //query 1 (3)
  List<StringIntegerChartData> _resultQueryData1 = [];
  //query 2 (4)
  List<List<String>> _resultQueryData2 = [];
  //query 3 (7)
  late _ResultsDataGridSource _resultsDataGridSource =  _ResultsDataGridSource([]);
  //query 4 (10)
  List<List<String>> _resultQueryData4 = [];

  //CALLED AT THE BEGINNING
  @override
  void initState() {
    _scrollCallback = widget.scrollCallback;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels <=
          constants.SCROLLCONTROLLER_POSITION_PIXELS) {
        _scrollCallback(constants.TOP);
      } else if (_scrollController.position.pixels >
          constants.SCROLLCONTROLLER_POSITION_PIXELS) {
        _scrollCallback(constants.BOTTOM);
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

  //HERE YOU SPECIFY THE LAYOUT
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: constants.PAGE_PADDING_PADDING_STYLE,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              constants.SIZED_BOX_BLOCK_STYLE,
              //query 1
              const ParagraphBlock(
                  title: "HomeTeam vs AwayTeam wins \n",
                  titleStyle: constants.BLOCK_PAGES_TITLE_STYLE_PARAGRAPH,
                  content: ["This query allows you to find how much the home ground affects the teams.\n"],
                  contentStyle: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH
              ),
              Padding(
                  padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
                  child: QueryCodeBlock(callbackQueryResult: callbackQueryResult1, editable: false, startQuery: constants.HARJOT_QUERY_1)
              ),
              Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
                child: SizedBox(width: double.infinity,height: 400, child:PieChartBlock(title: "HomeTeam VS AwayTeam Wins",chartData: _resultQueryData1))
              ),
              //query 2
              const ParagraphBlock(
                  title:"Teams with most international NBA Players (excluding USA)\n",
                  titleStyle: constants.BLOCK_PAGES_TITLE_STYLE_PARAGRAPH,
                  content: ["With this query you get the list of teams sorted by their number of international players.\n"],
                  contentStyle: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH
              ),
              Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
                child: QueryCodeBlock(callbackQueryResult: callbackQueryResult2, editable: false, startQuery: constants.HARJOT_QUERY_2)
              ),
              Padding(
                  padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
                  child: SizedBox(width: double.infinity, height: 400, child: TableBlock(tableData: _resultQueryData2, tableCols: constants.TABLE_COLUMNS_NAME_QUERY2_HARJOT))
              ),
              //query 3
              const ParagraphBlock(
                  title: "Miami vs Chicago\n",
                  titleStyle: constants.BLOCK_PAGES_TITLE_STYLE_PARAGRAPH,
                  content: ["With this query you get the results of the matches Miami vs Chicago of every season.\n"],
                  contentStyle: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH
              ),
              Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
                child: QueryCodeBlock(callbackQueryResult: callbackQueryResult3,editable: false, startQuery: constants.HARJOT_QUERY_3)
              ),
              Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
                child: SizedBox(width: double.infinity, height: 400, child: _buildDataGrid())
              ),
              //query 4 //SQUADRA CHE HA VINTO NELLA STAGIONE 2016 CON PIU’ GIOCATORI INTERNAZIONALI, che hanno giocato
              const ParagraphBlock(
                  title: "International Players of the winning team of NBA season 2015\n",
                  titleStyle: constants.BLOCK_PAGES_TITLE_STYLE_PARAGRAPH,
                  content: ["With this query you get the list of all the international players who have played in the winning team of season 2015.\n"],
                  contentStyle: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH),
              Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
                child: QueryCodeBlock(callbackQueryResult: callbackQueryResult4, editable: false, startQuery: constants.HARJOT_QUERY_4)
              ),
              Padding(
                  padding: constants.BLOCK_PAGES_PADDING_PADDING_STYLE,
                  child: SizedBox(width: double.infinity, height: 400, child: TableBlock(tableData: _resultQueryData4, tableCols: constants.TABLE_COLUMNS_NAME_QUERY4_HARJOT))
              ),
            ]
           ),
          ),
        );
  }

  //CALLBACKS
  callbackQueryResult1(var response) {
    List<StringIntegerChartData> list = [];

    int i=0;
    //Parse the response
    for (var data in response['results']['bindings']) {
      String winHome =
          data['winHome']['value'] == "0" ? "AwayWins" : "HomeWins";
      int numberOfGames = int.parse(data['numberOfGames']['value']);
      if(i%2==0){
        list.add(StringIntegerChartData(winHome,numberOfGames,constants.BLUE));
      }else{
        list.add(StringIntegerChartData(winHome,numberOfGames,constants.RED));
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

  callbackQueryResult3(var response) {
    var tempMap = {};

    //Parse the response
    for (var data in response['results']['bindings']) {
      int season = int.parse(data['season']['value']);
      bool isTeam1 = (int.parse(data['winClub1']['value'])) == 1;
      int wins = int.parse(data['totalWin']['value']);
      if (tempMap[season] == null) {
        tempMap[season] = {};
      }
      if (isTeam1) {
        bool hasOldWin2 =
            tempMap[season] != null && tempMap[season]["team2"] != null;
        if (hasOldWin2) {
          tempMap[season] = {"team1": wins, "team2": tempMap[season]["team2"]};
        } else {
          tempMap[season] = {"team1": wins};
        }
      } else {
        bool hasOldWin1 =
            tempMap[season] != null && tempMap[season]["team1"] != null;
        if (hasOldWin1) {
          tempMap[season] = {"team2": wins, "team1": tempMap[season]["team1"]};
        } else {
          tempMap[season] = {"team2": wins};
        }
      }
    }

    List<List<String>> t = [];

    List<_SeasonalResultTeamAB> temp = [];
    for (var season in tempMap.keys) {
      int team1Wins = tempMap[season]["team1"] ?? 0;
      int team2Wins = tempMap[season]["team2"] ?? 0;

      _SeasonalResultTeamAB cur =
          _generateRows(season, team1Wins + team2Wins, team1Wins, team2Wins);
      temp.add(cur);
    }
    _resultsDataGridSource._seasonalResultsTeamAB = temp;
    _resultsDataGridSource.updateDataGridRows();
    _resultsDataGridSource.updateDataGridSource();
  }

  callbackQueryResult4(var response) {
    List<List<String>> temp = [];

    //Parse the response
    for (var data in response['results']['bindings']) {
      String winnerTeam = data['winnerTeam']['value'];
      String playerName = data['playerName']['value'];
      String country = data['country']['value'];
      temp.add([winnerTeam, playerName, country]);
    }

    //Remove Previous Content
    _resultQueryData4.clear();

    //Add new content
    setState(() {
      _resultQueryData4.addAll(temp);
    });
  }

  //other methods

  //query 3
  Widget _buildDataGrid() {
    return Container(
        padding: constants.BLOCK_PAGES_CONTAINER_PADDING_STYLE,
        decoration: constants.BLOCK_PAGES_CONTAINER_DECORATION_STYLE,
        child: SfDataGrid(
          source: _resultsDataGridSource,
          columnWidthMode: ColumnWidthMode.fill,
          gridLinesVisibility: GridLinesVisibility.horizontal,
          headerGridLinesVisibility: GridLinesVisibility.none,
          columns: <GridColumn>[
            GridColumn(
              columnName: 'season',
              label: Container(
                  padding: constants.GRIDCOLUMN_CONTAINER_PADDING_STYLE,
                  alignment: Alignment.center,
                  child: const Text('Season',style: constants.BLOCK_PAGES_HEADER_COLUMN_STYLE)),
            ),
            GridColumn(
              columnName: 'totalMatch',
              label: Container(
                  padding: constants.GRIDCOLUMN_CONTAINER_PADDING_STYLE,
                  alignment: Alignment.center,
                  child: const Text('Total Matches', style: constants.BLOCK_PAGES_HEADER_COLUMN_STYLE)),
            ),
            GridColumn(
              columnName: 'matchWonByTeamA',
              label: Container(
                  padding: constants.GRIDCOLUMN_CONTAINER_PADDING_STYLE,
                  alignment: Alignment.center,
                  child: const Text('Bulls', style: constants.BLOCK_PAGES_HEADER_COLUMN_STYLE)),
            ),
            GridColumn(
              columnName: 'matchWonByTeamB',
              label: Container(
                  padding: constants.GRIDCOLUMN_CONTAINER_PADDING_STYLE,
                  alignment: Alignment.center,
                  child: const Text('Heat', style: constants.BLOCK_PAGES_HEADER_COLUMN_STYLE)),
            ),
            GridColumn(
                columnName: 'winloss',
                label:
                  Container(alignment: Alignment.center, child: const Text('W/L', style: constants.BLOCK_PAGES_HEADER_COLUMN_STYLE)))
          ]
        )
      );
  }

  _SeasonalResultTeamAB _generateRows(
      int season, int totalMatch, int matchWonByTeamA, int matchWonByTeamB) {
    return _SeasonalResultTeamAB(
        season,
        totalMatch,
        matchWonByTeamA,
        matchWonByTeamB,
        Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: SfSparkBarChart(
                data: [matchWonByTeamA, matchWonByTeamB],
                axisLineWidth: 0,

                color: constants.BLUE,
                trackball: const SparkChartTrackball())));
  }
}

class _SeasonalResultTeamAB {
  _SeasonalResultTeamAB(this.season, this.totalMatch, this.matchWonByTeamA,
      this.matchWonByTeamB, this.winloss);
  final int season;
  final int totalMatch;
  final int matchWonByTeamA;
  final int matchWonByTeamB;
  final Widget winloss;
}

class _ResultsDataGridSource extends DataGridSource {
  _ResultsDataGridSource(List<_SeasonalResultTeamAB> seasonalResultsTeamAB) {
    _seasonalResultsTeamAB = seasonalResultsTeamAB;
    updateDataGridRows();
  }

  List<_SeasonalResultTeamAB> _seasonalResultsTeamAB = [];
  List<DataGridRow> _seasonalResultTeamABData = [];

  void updateDataGridRows() {
    _seasonalResultTeamABData = _seasonalResultsTeamAB
        .map<DataGridRow>((_SeasonalResultTeamAB e) =>
            DataGridRow(cells: <DataGridCell<dynamic>>[
              DataGridCell<int>(columnName: 'season', value: e.season),
              DataGridCell<int>(columnName: 'totalMatch', value: e.totalMatch),
              DataGridCell<int>(
                  columnName: 'matchWonByTeamA', value: e.matchWonByTeamA),
              DataGridCell<int>(
                  columnName: 'matchWonByTeamB', value: e.matchWonByTeamB),
              DataGridCell<Widget>(columnName: 'winloss', value: e.winloss),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _seasonalResultTeamABData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: <Widget>[
      Container(
        alignment: Alignment.center,
        padding: constants.GRIDCOLUMN_CONTAINER_PADDING_STYLE,
        child: Text(row.getCells()[0].value.toString(),style: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH),
      ),
      Container(
        alignment: Alignment.center,
        padding: constants.GRIDCOLUMN_CONTAINER_PADDING_STYLE,
        child: Text(row.getCells()[1].value.toString(),style: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH),
      ),
      Container(
        alignment: Alignment.center,
        padding: constants.GRIDCOLUMN_CONTAINER_PADDING_STYLE,
        child: Text(row.getCells()[2].value.toString(),style: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH),
      ),
      Container(
        alignment: Alignment.center,
        padding: constants.GRIDCOLUMN_CONTAINER_PADDING_STYLE,
        child: Text(row.getCells()[3].value.toString(),style: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH),
      ),
      Container(
        padding: const EdgeInsets.all(3),
        child: row.getCells()[4].value,
      ),
    ]);
  }

  void updateDataGridSource() {
    notifyListeners();
  }
}
