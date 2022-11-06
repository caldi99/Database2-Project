import 'package:flutter/cupertino.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;

class ParagraphBlock extends StatelessWidget {

  const ParagraphBlock({
    super.key, required this.title,required this.paragraphText, required this.titleStyle, required this.paragraphStyle
  });

  final title;
  final paragraphText;
  final titleStyle;
  final paragraphStyle;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: title,
        style: titleStyle,
        children: <TextSpan>[
          for(String pharse in paragraphText.split('\n')) ... [
              TextSpan(
                  text: pharse + '\n',
                  style: paragraphStyle
              )
            ]
        ],
      ),
    );
  }
}