import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;

import '../backend/query_handler.dart';

class QueryPromptBlock extends StatefulWidget {
  const QueryPromptBlock({super.key,this.callbackQueryResult,this.editable,this.startQuery});
  final callbackQueryResult;
  final editable;
  final startQuery;

  @override
  _QueryPromptBlock createState() => _QueryPromptBlock();
}

class _QueryPromptBlock extends State<QueryPromptBlock> {
  late final callbackQueryResult;
  CodeController? _codeController;
  late final bool editable;
  late final String startQuery;
  Color borderColorFocused = constants.BLUE;
  Color borderColor = Colors.grey;

  @override
  void initState() {
    editable = widget.editable;
    callbackQueryResult = widget.callbackQueryResult;
    startQuery = widget.startQuery;
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
          child: Stack(
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

                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: SingleChildScrollView(
                            child: CodeField(
                              minLines: 13,
                              controller: _codeController!,
                              enabled: editable,
                              textStyle: TextStyle(fontFamily: 'SourceCode',
                                  wordSpacing: 5,
                                  fontSize: 20),
                            )
                        )

                    ),
                  )
              ),
              Positioned(
                  right: 15,
                  bottom: 20,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        String query = _codeController!.text.toString();
                        query = query.replaceAll('·', ' ');
                        print(query);
                        GraphDBAnswer answer=await QueryHandler.httpRequestGraphDb(
                            query, true, true);
                        if(answer.isError){
                          SnackBar snackBar = SnackBar(
                            content: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.error_outline,color: Colors.red,),
                                SizedBox(width: 10,),
                                Text(answer.msg),
                              ],
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        else{
                          callbackQueryResult(answer.msg);
                        }
                      }
                      catch (exception) {
                        SnackBar snackBar = SnackBar(
                          content: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error_outline,color: Colors.red,),
                              SizedBox(width: 10,),
                              Text(exception.toString(),),
                            ],
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(10),
                      //buttons Material shadow
                      shape: MaterialStateProperty.all(const CircleBorder()),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.all(20)),
                      backgroundColor: MaterialStateProperty.all(
                          constants.BLUE),
                      // <-- Button color
                      overlayColor: MaterialStateProperty.resolveWith<Color?>((
                          states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.blueAccent; // <-- Splash color
                      }),
                    ),
                    child: const Icon(Icons.send, size: 40,),
                  )
              )
            ],
          ),)
    );
  }
}