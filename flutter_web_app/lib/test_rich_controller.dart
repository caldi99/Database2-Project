
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';

class QueryInput2 extends StatefulWidget {
  const QueryInput2({ super.key });

  @override
  State<QueryInput2> createState() => _QueryInput2();
}

class _QueryInput2 extends State<QueryInput2> {

  CodeController? _codeController;

  @override
  void initState() {
    super.initState();
    final source = '''// Add your code here :)''';
    // Instantiate the CodeController
    _codeController = CodeController(
      text: source,
      //language: sql,
      //theme: monokaiSublimeTheme,
    );
  }

  @override
  Widget build(BuildContext context) {
    /*return const TextField(
        keyboardType: TextInputType.multiline,
        maxLines: 15,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          contentPadding: EdgeInsets.only(top:30,bottom: 30,left: 25,right: 25),
          hintText: 'Type your query here...',
        )

    );*/
    /*
 */
    return CodeField(
      controller: _codeController!,
      textStyle: TextStyle(fontFamily: 'SourceCode'),
    );
  }
}
