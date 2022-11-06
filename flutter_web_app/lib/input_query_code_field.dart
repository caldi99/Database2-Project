import 'package:flutter/material.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;
import 'package:flutter_web_app/backend/query_handler.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';


class QueryInputCode extends StatefulWidget {
  const QueryInputCode({super.key,this.callbackQueryResult,this.editable,this.startQuery});
  final callbackQueryResult;
  final editable;
  final startQuery;

  @override
  _QueryInputCode createState() => _QueryInputCode();
}

class _QueryInputCode extends State<QueryInputCode> {
  late final callbackQueryResult;
  CodeController? _codeController;
  late final bool editable;
  late final String startQuery;
// Add a controller

  Color borderColorFocused=constants.BLUE;
  Color borderColor=Colors.grey;

  @override
  void initState() {
    editable=widget.editable;
    callbackQueryResult=widget.callbackQueryResult;
    startQuery=widget.startQuery;
    // Instantiate the CodeController
    _codeController = CodeController(

        text: startQuery,
        language: constants.sparql,
        theme: atomOneDarkTheme,
    );
    super.initState();
  }

  @override
  void dispose() {
    _codeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
        height: 315,
        child: Center(
          child:Stack(

          children: [
            Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 3,
                        blurRadius: 8,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),

                  child:ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child:SingleChildScrollView(
                          child: CodeField(
                            minLines: 13,
                            controller: _codeController!,
                            enabled: editable,
                            textStyle: TextStyle(fontFamily: 'SourceCode',wordSpacing: 5,fontSize: 20),
                          )
                      )

                  ),
                )
            ),


            /*(editable)?Container(width: 0,height: 0,color: Colors.transparent,):Positioned.fill(
                child: Container(
                )
            ),*/




            Positioned(
                right: 15,
                bottom: 20,
                child:ElevatedButton(
                  onPressed: () async {
                    try {
                      String query=_codeController!.text.toString();
                      query=query.replaceAll('·', ' ');
                      print(query);
                      var json = await QueryHandler.httpRequestGraphDb(
                          query, true, true);
                      callbackQueryResult(json);
                      setState(() {
                        borderColor=Colors.grey;
                        borderColorFocused=constants.BLUE;
                      });
                    }
                    catch(exception){
                      print(exception);
                      setState(() {
                        borderColor=constants.RED;
                        borderColorFocused=constants.RED;
                      });
                    }
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


