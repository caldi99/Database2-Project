import 'package:flutter/cupertino.dart';
import 'package:flutter_web_app/page_blocks/date_number_chart_data.dart';
import 'package:flutter_web_app/page_blocks/query_prompt_block.dart';
import 'package:flutter_web_app/page_blocks/paragraph_block.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;

import '../page_blocks/histogram_date_number_chart_block.dart';

class FrancescoQueryPage extends StatefulWidget{

  const FrancescoQueryPage({Key? key,this.scrollCallback}) : super(key: key);
  final scrollCallback;
  @override
  State<FrancescoQueryPage> createState() => _FrancescoQueryPage();
}

class _FrancescoQueryPage extends State<FrancescoQueryPage> {
  final ScrollController _scrollController=ScrollController();
  late final scrollCallback;
  final query1 = """PREFIX base: <https://www.dei.unipd.it/Database2/CPS-NBA/>
  PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
  SELECT ?matchDate ?pts WHERE {
?person base:wasPlayer ?player ;
base:name "LeBron James"^^xsd:string .
?player base:appearsIn ?appearance .
?appearance base:pts ?pts ;
base:refersTo ?game .
?game base:matchDate ?matchDate .
FILTER( ?matchDate >= "2017-10-01"^^xsd:date && ?matchDate <= "2018-07-31"^^xsd:date) .
}""";
  final query2 = """PREFIX base: <https://www.dei.unipd.it/Database2/CPS-NBA/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
SELECT (SUM(?minutes) as ?totalMinutesPlayer) (SUM(?seconds) as ?totalSecondsPlayer) ?name WHERE {
	?player base:playedFor ?club ;
		base:appearsIn ?appearance ;
		base:startYear "2006"^^xsd:gYear ;
		base:endYear "2007"^^xsd:gYear ;
		base:represents ?person .
	?person base:name ?name .
	?club base:nickname "Bulls"^^xsd:string .
	?appearance base:minutes ?minutes ;
				base:seconds ?seconds .	
}GROUP BY (?name)
""";

  List<DateNumberChartData> resultQueryData1 = [];


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

  //HERE YOU SPECIFY THE LAYOUT
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 150,
              ),
              const ParagraphBlock(
                title: "LeBron James points during 2017-2018 season\n",
                titleStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: constants.SIZE_H2,
                  height: 3,
                ),
                paragraphText: "This query finds the points scored by LeBron James during the 2017-2018 season.\n",
                paragraphStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: constants.SIZE_TEXT,
                    height: 1.2
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 150,right: 150,top: 20,bottom: 20),
                child: QueryPromptBlock(callbackQueryResult: callbackQueryResult1,editable: false,startQuery: query1),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 150,right: 150,top: 20,bottom: 20),
                  child:SizedBox(width: double.infinity,height: 400, child:HistogramDateNumberChartBlock(chartData: resultQueryData1,),)
              ),
              const ParagraphBlock(
                title: "Chicago Bulls team during the 2006-2007 season with the corresponding time played\n",
                titleStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: constants.SIZE_H2,
                  height: 3,
                ),
                paragraphText: "This query finds who played for the Chicago Bulls team during the 2006-2007 season and how much time was played for each player.\n",
                paragraphStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: constants.SIZE_TEXT,
                    height: 1.2
                ),
              ),              
              Padding(
                padding: const EdgeInsets.only(left: 150,right: 150,top: 20,bottom: 20),
                child: QueryPromptBlock(callbackQueryResult: callbackQueryResult2,editable: false,startQuery: query2),
              )              
            ],
          ),
        )
    );
  }

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
    resultQueryData1.clear();

    //Add new content
    setState(() {
      resultQueryData1.addAll(list);
    });
  }

  callbackQueryResult2(var response){
    print(response);
  }

}