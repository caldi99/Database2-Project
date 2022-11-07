import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_web_app/home_vs_away_wins_chart.dart';
import 'package:flutter_web_app/html_graph_visualizer.dart';
import 'package:flutter_web_app/page_blocks/link_bock.dart';
import 'package:flutter_web_app/page_blocks/paragraph_block.dart';
import 'package:flutter_web_app/page_blocks/query_code_block.dart';
import 'package:flutter_web_app/paragraphs.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;

class MainPage extends StatefulWidget {
  const MainPage({Key? key, this.scrollCallback}) : super(key: key);
  final scrollCallback;
  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  List<List<String>> elementsQueried=[];
  List<String> columns=[];
  final ScrollController _scrollController=ScrollController();
  late final _scrollCallback;


  callbackQueryResult(var result){
    print(result);
    elementsQueried.clear();
    columns.clear();

    List<List<String>> elements=[];
    List<String> columnsTemp=[];

    for (String column in result['head']['vars']){
      columnsTemp.add(column);
    }
    setState(() {
      columns.addAll(columnsTemp);
    });
    print(columns.length);

    int k=0;
    for (var elem in result['results']['bindings']){

      List<String> valuesK=[];
      for (int i=0;i<columns.length;i++){
        valuesK.add(elem[columns[i]]['value']);
      }
      elements.add(valuesK);
      k++;
    }

    setState(() {
      elementsQueried.addAll(elements);
    });

  }

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


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
            ParagraphBlock(
                title: 'NBA-CPS: Our Ontology\n',
                content: ['This is a Web-App that can be used to make SPARQL queries to the NBA Ontology we created.\n',
                  'Our aim is firstly to provide here an insight of the Ontology making a visual graph representing the classes and their properties and relationships. ',
                  'We also make here available a set of queries that we thought to be valuable. For these queries it is possible to visualize some charts. ',
                      'Finally, we implemented a Text-Box where you can type your query and view the results in tabular form.\n',
                      'The data used are provided by Kaggle. You can download the .csv files by clicking the following URLs:\n'],
                titleStyle: constants.BLOCK_PAGES_TITLE_STYLE_PARAGRAPH,
                contentStyle: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH),
            LinkBlock(
                value: "-  NBA Players",
                url: "https://www.kaggle.com/datasets/justinas/nba-players-data",
                style: constants.BLOCK_PAGES_LINK_STYLE
            ),
            LinkBlock(
                  value: "-  NBA games data",
                  url: "https://www.kaggle.com/datasets/nathanlauga/nba-games",
                  style: constants.BLOCK_PAGES_LINK_STYLE
            ),
            ParagraphBlock(
                  title: "How the Graph looks\n",
                  content: ["Here we provide an interactive sandboc with d3js where you can see which are our classes and their relationships.\n"],
                  titleStyle: constants.BLOCK_PAGES_TITLE_STYLE_PARAGRAPH,
                  contentStyle: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH
            ),
            const Padding(
              padding: constants.BLOCK_PAGES_PADDING_PADDING_PROPRIETY,
              child: GraphIFrame(), //TODO: REFACTORING DONE UNTIL HERE
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                      height: 400,
                      // A couple of charts
                      child:Row(
                        children: const [
                          Expanded(
                            flex: 3,
                            child:SizedBox(),
                          ),
                          Expanded(
                            flex: 12,
                            child:HomeVsAwayWinsChart(),
                          ),
                          Expanded(
                            flex: 3,
                            child:SizedBox(),
                          ),
                          Expanded(
                            flex:12,
                            child:HomeVsAwayWinsChart(),
                          ),
                          Expanded(
                            flex: 3,
                            child:SizedBox(),
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(20.0),
              child: QueryParagraph(),
            ),

            Padding(
                padding: (columns.length>0)?EdgeInsets.only(top:20,bottom: 10,left: 100,right: 100):EdgeInsets.only(top:20,bottom: 50,left: 100,right: 100),
                child:QueryCodeBlock(callbackQueryResult:callbackQueryResult,editable: true, startQuery: "# Add your query here :)",)
            ),

            (columns.length>0)?Padding(
              padding: EdgeInsets.only(left: 100,right: 100),
              child:Container(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  height: 80,
                  decoration: BoxDecoration(
                    color: constants.BLUE,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20),),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 3,
                        blurRadius: 8,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child:Row(

                    children: List<Widget>.generate(columns.length, (i) {
                      return Expanded(
                        flex: 1,
                        child:Text(columns[i],style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),

                      );
                    }
                    ),
                  )
              ),
            ):SizedBox(),
            (columns.length>0)?Padding(
              padding: EdgeInsets.only(left: 100,right: 100,bottom: 50),
              child:
              Container(
                height: 600,
                padding: EdgeInsets.only(left: 20,right: 20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20),),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child:ListView.separated(

                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.grey,

                    ),
                    itemCount: elementsQueried.length,
                    itemBuilder: (BuildContext context, int index) {
                      if(index==0){
                        return Container(
                            height: 35,
                            padding: EdgeInsets.only(top:5),
                            child:Row(
                              children: List<Widget>.generate(elementsQueried[0].length, (i) {
                                return Expanded(
                                  flex: 1,
                                  child:Text(elementsQueried[index][i],textAlign: TextAlign.center,),
                                );
                              }),
                            )
                        );
                      }
                      return SizedBox(
                          height: 30,
                          child:Row(
                            children: List<Widget>.generate(elementsQueried[0].length, (i) {
                              return Expanded(
                                flex: 1,
                                child:Text(elementsQueried[index][i],textAlign: TextAlign.center,),
                              );
                            }),
                          )
                      );
                    }),
              ),
            ):SizedBox(),
          ],
        )
      )
    );
  }
}