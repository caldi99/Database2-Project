import 'package:flutter/material.dart';
import 'package:flutter_web_app/constants.dart' as constants;
import 'package:flutter_web_app/query_handler.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/src/common_modes.dart';
import 'package:highlight/highlight_core.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';


class QueryInputCode extends StatefulWidget {
  const QueryInputCode({super.key,this.callbackQueryResult});
  final callbackQueryResult;

  @override
  _QueryInputCode createState() => _QueryInputCode();
}

class _QueryInputCode extends State<QueryInputCode> {
  late final callbackQueryResult;
  CodeController? _codeController;
// Add a controller

  Color borderColorFocused=constants.BLUE;
  Color borderColor=Colors.grey;

  @override
  void initState() {
    callbackQueryResult=widget.callbackQueryResult;
    final start_text = "# Add your query here :)";
    // Instantiate the CodeController
    _codeController = CodeController(

        text: start_text,
        language: sparql,
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
        height: 300,
        child: Center(child:Stack(

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
                      child: CodeField(
                        controller: _codeController!,
                        textStyle: TextStyle(fontFamily: 'SourceCode',wordSpacing: 5,fontSize: 20),
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


final sparql = Mode(
    refs: {
      '~contains~0~contains~5':
      Mode(className: "comment", begin: "#", end: "\$", contains: [
        PHRASAL_WORDS_MODE,
        Mode(
            className: "doctag",
            begin: "(?:TODO|FIXME|NOTE|BUG|XXX):",
            relevance: 0)
      ]),
    },
    case_insensitive: true,
    illegal: "[<>{}*]",
    contains: [
      Mode(
          beginKeywords: "select prefix insert",
          end: ";",
          endsWithParent: true,
          lexemes: "[\\w\\.]+",
          keywords: {
            "keyword": "select prefix insert as order by distinct where count from limit",
            "literal": "true false null unknown",
            "built_in":
            "array bigint binary bit blob bool boolean char character date dec decimal float int int8 integer interval number numeric real record serial serial8 smallint text time timestamp tinyint varchar varchar2 varying void"
          },
          contains: [
            Mode(
                className: "string",
                begin: "'",
                end: "'",
                contains: [Mode(begin: "''")]),
            Mode(
                className: "string",
                begin: "\"",
                end: "\"",
                contains: [Mode(begin: "\"\"")]),
            Mode(className: "string", begin: "`", end: "`"),
            C_NUMBER_MODE,
            C_BLOCK_COMMENT_MODE,
            Mode(ref: '~contains~0~contains~5'),
            HASH_COMMENT_MODE
          ]),
      C_BLOCK_COMMENT_MODE,
      Mode(ref: '~contains~0~contains~5'),
      HASH_COMMENT_MODE
    ]);

