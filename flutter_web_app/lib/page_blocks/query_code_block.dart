import 'package:flutter/material.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;
import 'package:flutter_web_app/backend/query_handler.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';


class QueryCodeBlock extends StatefulWidget {
  //DATA MEMEBERS
  final callbackQueryResult;
  final editable;
  final startQuery;

  const QueryCodeBlock({super.key,this.callbackQueryResult,this.editable,this.startQuery});

  @override
  _QueryInputCode createState() => _QueryInputCode();
}

class _QueryInputCode extends State<QueryCodeBlock> {
  late final callbackQueryResult;
  CodeController? _codeController;
  late final bool editable;
  late final String startQuery;


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
                        offset: const Offset(0, 3), // changes position of shadow
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
                            textStyle: const TextStyle(fontFamily: 'SourceCode',fontSize: 20),
                          )
                      )
                  ),
                )
            ),
            Positioned(
                right: 15,
                bottom: 20,
                child:ElevatedButton(
                  onPressed: () async {
                    try {
                      String query = _codeController!.text.toString();
                      query = query.replaceAll('·', ' ');
                      GraphDBAnswer answer = await QueryHandler.httpRequestGraphDb(query, true, true);
                      if(answer.isError){
                        SnackBar snackBar = SnackBar(
                          content: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.error_outline,color: Colors.red),
                              const SizedBox(width: 10,),
                              Text(answer.msg.toString()),
                            ],
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      else{
                        callbackQueryResult(answer.msg);
                      }
                    }
                    catch(exception){
                      SnackBar snackBar = SnackBar(
                        content: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline,color: Colors.red,),
                            const SizedBox(width: 10,),
                            Text(exception.toString(),),
                          ],
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(10), //buttons Material shadow
                    shape: MaterialStateProperty.all(const CircleBorder()),
                    padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                    backgroundColor: MaterialStateProperty.all(constants.BLUE), // <-- Button color
                    overlayColor: MaterialStateProperty.resolveWith<Color?>((states)
                    {
                      if (states.contains(MaterialState.pressed))
                        return Colors.blueAccent; // <-- Splash color
                    }),
                  ),
                  child: const Icon(Icons.play_arrow_rounded,size: 40),
                )
            )
          ],
        ),)
    );
  }
}


