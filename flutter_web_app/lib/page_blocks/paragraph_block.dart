import 'package:flutter/cupertino.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;

class ParagraphBlock extends StatelessWidget {

  //DATA MEMBERS
  final title;
  final content;
  final titleStyle;
  final contentStyle;

  const ParagraphBlock({
    super.key, required this.title,required this.content, required this.titleStyle, required this.contentStyle
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: title,
        style: titleStyle,
        children: <TextSpan>[
          for(String pharse in content) ... [
              TextSpan(
                  text: pharse,
                  style: contentStyle
              )
            ]
        ],
      ),
    );
  }
}