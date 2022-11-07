import 'package:flutter/material.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;
class HarjotQueryPage extends StatefulWidget {
  final scrollCallback;

  const HarjotQueryPage({Key? key,this.scrollCallback}) : super(key: key);

  @override
  State<HarjotQueryPage> createState() => _QueryPage3();
}

class _QueryPage3 extends State<HarjotQueryPage> {

  //DATA MEMBERS
  final ScrollController _scrollController=ScrollController();
  late final _scrollCallback;

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