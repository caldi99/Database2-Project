import 'package:flutter/material.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;
import 'package:flutter_web_app/page_blocks/query_code_block.dart';
import 'package:flutter_web_app/paragraphs.dart';
import 'package:flutter_web_app/top_played_arenas_chart.dart';
import 'package:flutter_web_app/top_scorers_chart.dart';


class AndreaQueryPage extends StatefulWidget {
  final scrollCallback;

  const AndreaQueryPage({Key? key,this.scrollCallback}) : super(key: key);

  @override
  State<AndreaQueryPage> createState() => _QueryPage1();
}

class _QueryPage1 extends State<AndreaQueryPage> {
  //DATA MEMBERS
  final ScrollController _scrollController=ScrollController();
  late final _scrollCallback;
  List<TopScorersChartData> dataTopScorers=[];
  List<TopArenasChartData> dataTopArenas=[];

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
            QueryPage1FirstQueryParagraph(),
            Padding(
              padding: constants.BLOCK_PAGES_PADDING_PADDING_PROPRIETY,
              child:QueryCodeBlock(callbackQueryResult:callbackQueryResultTopScorers,editable: false,startQuery: constants.ANDREA_QUERY_1)
            ),
            Padding(
              padding: constants.BLOCK_PAGES_PADDING_PADDING_PROPRIETY,
              child:SizedBox(width: double.infinity,height: 400, child:TopScorersChart(data: dataTopScorers))
            ),
            QueryPage1SecondQueryParagraph(),
            Padding(
              padding: constants.BLOCK_PAGES_PADDING_PADDING_PROPRIETY,
              child:QueryCodeBlock(callbackQueryResult:callbackQueryResultTopArenas,editable: false,startQuery: constants.ANDREA_QUERY_2)
            ),
            Padding(
                padding: constants.BLOCK_PAGES_PADDING_PADDING_PROPRIETY,
                child:SizedBox(width: double.infinity,height: 400, child:TopArenasChart(data: dataTopArenas))
            ),
          ],
        ),
      )
    );
  }

  //CALLBACKS

  callbackQueryResultTopArenas(var res){
    List<TopArenasChartData> temp=[];

    int tot=0;
    for (var r in res['results']['bindings']){
      tot++;
    }

    int i=0;
    for (var result  in res['results']['bindings']){
      String name=result['name']['value'];
      int capacity=double.parse(result['capacity']['value']) as int;
      int numberOfGames=double.parse(result['numberOfGames']['value']) as int;
      Color? color=Color.lerp(constants.BLUE, constants.RED, i*1.0/tot);
      //Color color=Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
      temp.add(TopArenasChartData(name,numberOfGames, capacity, color!));
      i++;
    }

    dataTopScorers.clear();

    setState(() {
      dataTopArenas.addAll(temp);
    });
  }

  callbackQueryResultTopScorers(var res){
    List<TopScorersChartData> temp=[];
    int tot=0;

    for (var r in res['results']['bindings']){
      tot++;
    }

    int i=0;
    for (var result  in res['results']['bindings']){
      String name=result['name']['value'];
      int pointsScored=int.parse(result['points']['value']);
      //Color color=Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
      Color? color=Color.lerp(constants.BLUE, constants.RED, i*1.0/tot);
      temp.add(TopScorersChartData(name, pointsScored, color!));
      i++;
    }

    dataTopScorers.clear();

    setState(() {
      dataTopScorers.addAll(temp);
    });

  }
}