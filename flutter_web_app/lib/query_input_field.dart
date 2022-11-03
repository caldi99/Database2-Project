import 'package:flutter/material.dart';
import 'package:flutter_web_app/query_handler.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:flutter_web_app/constants.dart' as constants;
class QueryInput extends StatefulWidget {
  const QueryInput({super.key,this.callbackQueryResult});
  final callbackQueryResult;

  @override
  _QueryInput createState() => _QueryInput();
}

class _QueryInput extends State<QueryInput> {
  late final callbackQueryResult;
// Add a controller
  late RichTextController _controller;

  @override
  void initState() {
    callbackQueryResult=widget.callbackQueryResult;
    _controller = RichTextController(
      stringMatchMap: {
        "FILTER":const TextStyle(color: constants.RED,fontWeight: FontWeight.bold),
        "PREFIX":const TextStyle(color: constants.RED, fontWeight: FontWeight.bold),
        "SELECT":const TextStyle(color: constants.RED,fontWeight: FontWeight.bold),
        "WHERE":const TextStyle(color: constants.RED, fontWeight: FontWeight.bold),
        "INSERT":const TextStyle(color: constants.RED,fontWeight: FontWeight.bold),
        "AS":const TextStyle(color: constants.RED, fontWeight: FontWeight.bold),
        "BIND":const TextStyle(color: constants.RED,fontWeight: FontWeight.bold),
        "CONCAT":const TextStyle(color: constants.RED, fontWeight: FontWeight.bold),
        "DISTINCT":const TextStyle(color: constants.RED,fontWeight: FontWeight.bold),
        "FROM":const TextStyle(color: constants.RED,fontWeight: FontWeight.bold),
        "ORDER BY":const TextStyle(color: constants.RED,fontWeight: FontWeight.bold),
        "LIMIT":const TextStyle(color: constants.RED,fontWeight: FontWeight.bold),


        /*"}":const TextStyle(color: constants.BLUE,fontWeight: FontWeight.bold),
        "?":const TextStyle(color: constants.BLUE,fontWeight: FontWeight.bold),*/
      },

      //* onMatch callback that gives you access to a List<String>
      //* which contains all matched strings
      onMatch: (List<String> matches){
        // Do something with matches.
        //! P.S
        // as long as you're typing, the controller will keep updating the list.
      },
      deleteOnBack: false,

    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 300,
      child: Center(child:Stack(

        children: [
          Positioned.fill(
              child: SizedBox(
                  child: TextField(

                    controller: _controller,
                    keyboardType: TextInputType.multiline,
                    maxLines: 15,
                    cursorColor: constants.BLUE,
                    decoration: const InputDecoration(

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),

                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: constants.BLUE, width: 2.0),

                      ),
                      contentPadding: EdgeInsets.only(top:30,bottom: 30,left: 25,right: 25),
                      hintText: 'Type your query here...',
                    ),

                  )
              )
          ),

          Positioned(
            right: 15,
            bottom: 20,
            child:ElevatedButton(


              onPressed: () async {
                var json=await QueryHandler.httpRequestGraphDb(_controller.text, true, true);
                callbackQueryResult(json);

                },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(10), //buttons Material shadow
                shape: MaterialStateProperty.all(const CircleBorder()),
                padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                backgroundColor: MaterialStateProperty.all(constants.BLUE), // <-- Button color
                overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(MaterialState.pressed)) return Colors.blueAccent; // <-- Splash color
                }),
              ),
              child: const Icon(Icons.send,size: 40,),
            )
          )
        ],
      ),)
    );
      
      
  }
}