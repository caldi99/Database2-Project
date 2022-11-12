import 'package:flutter/material.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;


// This is the file where the header style is defined
class HeaderBlock extends StatefulWidget {
  const HeaderBlock({
    super.key,
    required this.sizeAnimation,
    required this.goToPage,
  });
  final HeaderSize sizeAnimation;
  final goToPage;

  @override
  State<HeaderBlock> createState() => _HeaderBlock();
}

class _HeaderBlock extends State<HeaderBlock> {
  //DATA MEMBERS
  late final HeaderSize _sizeAnimation;
  final roundBorderSize = 40.0;
  late final goToPage;

  @override
  void initState() {
    _sizeAnimation=widget.sizeAnimation;
    goToPage = widget.goToPage;
    super.initState();
  }
  //TODO : SOME PARTS ARE LEFT HARDCODED NO CONSTANTS CREATED TOO MUCH CHANGES OK TO LEAVE IT LIKE IT IS
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
              style: constants.BLOCK_PAGES_TEXTBUTTON_STYLE,
              onPressed: () {goToPage(constants.HOME_PAGE_INDEX);},
              child: Container(
                padding: const EdgeInsets.only(left:20,top:20,bottom: 20),
                child:ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset("assets/logo.png", fit:BoxFit.fitHeight),
                ),
              ),
            ),
            Container(
                padding: constants.BLOCK_PAGES_CONTAINER_PADDING_STYLE,
                child:Align(
                    alignment: Alignment.center,
                    child:AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 300),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 80.0 * (_sizeAnimation.size / 200.0), color: Colors.white),
                      child: Text('NBA Ontology'),
                    ),
                )
            ),
            Expanded(child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextButton(
                    style: constants.BLOCK_PAGES_TEXTBUTTON_STYLE,
                    onPressed: () {goToPage(constants.ANDREA_QUERY_PAGE_INDEX);},
                    child: const Text('Andrea Query Page',style: constants.BLOCK_PAGES_TEXTBUTTON_TEXT_STYLE),
                  ),
                  TextButton(
                    style: constants.BLOCK_PAGES_TEXTBUTTON_STYLE,
                    onPressed: () {goToPage(constants.FRANCESCO_QUERY_PAGE_INDEX);},
                    child: const Text('Francesco Query Page',style: constants.BLOCK_PAGES_TEXTBUTTON_TEXT_STYLE),
                  ),
                  TextButton(
                    style: constants.BLOCK_PAGES_TEXTBUTTON_STYLE,
                    onPressed: () {goToPage(constants.HARJOT_QUERY_PAGE_INDEX);},
                    child: const Text('Harjot Query Page',style: constants.BLOCK_PAGES_TEXTBUTTON_TEXT_STYLE),
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







