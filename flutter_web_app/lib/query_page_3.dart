import 'package:flutter/material.dart';
import 'package:flutter_web_app/constants.dart' as constants;
class QueryPage3 extends StatefulWidget {
  const QueryPage3({Key? key,this.scrollCallback}) : super(key: key);
  final scrollCallback;
  @override
  State<QueryPage3> createState() => _QueryPage3();
}

class _QueryPage3 extends State<QueryPage3> {
  final ScrollController _scrollController=ScrollController();
  late final scrollCallback;

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
          Text("QueryPage3"),
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