import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_web_app/constants.dart' as constants;


// This is the file where the header style is defined
class CustomHeader extends StatefulWidget {
  const CustomHeader({
    super.key,
    required this.sizeAnimation,
  });
  final Animation sizeAnimation;
  @override
  State<CustomHeader> createState() => _CustomHeader();
}

class _CustomHeader extends State<CustomHeader> {
  late final Animation _sizeAnimation;
  final roundBorderSize=40.0;
  @override
  void initState() {
    _sizeAnimation=widget.sizeAnimation;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        height: _sizeAnimation.value,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          gradient: const LinearGradient(
            colors: [constants.BLUE, constants.RED],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.zero,
            topRight: Radius.zero,
            bottomLeft: Radius.circular(roundBorderSize),
            bottomRight: Radius.circular(roundBorderSize),
          ),
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
          children: [
            Container(
                padding: EdgeInsets.only(left:20,top:20,bottom: 20),

                child:ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                      "assets/logo.png",
                      fit:BoxFit.fitHeight
                  ),
                )
            ),
            Container(
                padding: EdgeInsets.only(left:20,top:20,bottom: 20,right:20),
                //height: double.infinity,
                child:Align(
                    alignment: Alignment.center,

                    child:Text( 'NBA Ontology',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 80.0*(_sizeAnimation.value/200.0),
                        color: Colors.white,

                      ),
                    )
                )
            ),
          ],
        )
    );
  }
}




