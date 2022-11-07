import 'package:flutter/material.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;


// This is the file where the header style is defined
class CustomHeader extends StatefulWidget {
  const CustomHeader({
    super.key,
    required this.sizeAnimation,
    required this.goToPage,
  });
  final HeaderSize sizeAnimation;
  final goToPage;

  @override
  State<CustomHeader> createState() => _CustomHeader();
}

class _CustomHeader extends State<CustomHeader> {
  late final HeaderSize _sizeAnimation;
  final roundBorderSize=40.0;
  late final goToPage;

  @override
  void initState() {
    _sizeAnimation=widget.sizeAnimation;
    goToPage=widget.goToPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
        height: _sizeAnimation.size,
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
            TextButton(
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent)
              ),
              onPressed: () {goToPage(constants.HOME_PAGE);},
              child: Container(
                padding: const EdgeInsets.only(left:20,top:20,bottom: 20),

                child:ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                      "assets/logo.png",
                      fit:BoxFit.fitHeight
                  ),
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left:20,top:20,bottom: 20,right:20),
                //height: double.infinity,
                child:Align(
                    alignment: Alignment.center,
                  child:AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 300),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 80.0*(_sizeAnimation.size/200.0),
                      color: Colors.white,

                    ),
                    child: Text('NBA Ontology'),
                  ),
                )
            ),
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.transparent)
                  ),
                  onPressed: () {goToPage(constants.QUERY_PAGE_1);},
                  child: const Text('Andrea Query Page',style: TextStyle(fontSize: 20,color: Colors.white), ),
                ),
                TextButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.transparent)
                  ),
                  onPressed: () {goToPage(constants.QUERY_PAGE_2);},
                  child: const Text('Francesco Query Page',style: TextStyle(fontSize: 20,color: Colors.white), ),
                ),
                TextButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.transparent)
                  ),
                  onPressed: () {goToPage(constants.QUERY_PAGE_3);},
                  child: const Text('Harjot Query Page',style: TextStyle(fontSize: 20,color: Colors.white), ),
                ),
              ],
            )
            )

          ],
        )
    );
  }
}

class HeaderSize{
  HeaderSize(this.size);
  double size;
}







