import 'package:flutter/material.dart';
import 'package:flutter_web_app/constants.dart' as constants;
class QueryPage1 extends StatefulWidget {
  const QueryPage1({Key? key,this.scrollCallback}) : super(key: key);
  final scrollCallback;
  @override
  State<QueryPage1> createState() => _QueryPage1();
}

class _QueryPage1 extends State<QueryPage1> {
  final ScrollController _scrollController=ScrollController();
  //bool scrollTop=true;
  late final scrollCallback;


  //CALLED AT THE BEGINNING
  @override
  void initState() {

    scrollCallback=widget.scrollCallback;
    _scrollController.addListener(() {
      //print(_scrollController.position.pixels.toString()+" "+ scrollTop.toString());
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
      child:Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            color: constants.BLUE,
          ),
          Container(
            height: 300,
            width: double.infinity,
            color: constants.RED,
          ),
          Text("QueryPage1"),
          Container(
            height: 300,
            width: double.infinity,
            color: constants.BLUE,
          ),

          Container(
            height: 300,
            width: double.infinity,
            color: constants.RED,
          ),

        ],
      ),
    );
  }
}