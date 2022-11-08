import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;
// This is the file where all the texts in our web-app should be placed

const double HEIGHT=3;

class ChartParagraph extends StatelessWidget {
  const ChartParagraph({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(

      text: const TextSpan(
        text: 'Data Insight\n',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: constants.SIZE_H2,
          height: HEIGHT,
        ),
        children: <TextSpan>[
          TextSpan(text: 'We extracted data from the aforementioned datasets. We provide here some charts illustrating some info about the datasets:'
              , style: TextStyle(fontWeight: FontWeight.normal,fontSize: constants.SIZE_TEXT,height: 1.2)),
        ],
      ),
    );
  }
}

class QueryParagraph extends StatelessWidget {
  const QueryParagraph({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(

      text: const TextSpan(
        text: 'Queries\n',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: constants.SIZE_H2,
          height: HEIGHT,
        ),
        children: <TextSpan>[
          TextSpan(text: 'We provide a set of default queries for which we extracted data in other pages that can be accessed from our Header. '
              , style: TextStyle(fontWeight: FontWeight.normal,fontSize: constants.SIZE_TEXT,height: 1.2)),
          TextSpan(text: 'You can select one of these and some default queries will be executed to get relevant data from our GraphDB server.\n'
              , style: TextStyle(fontWeight: FontWeight.normal,fontSize: constants.SIZE_TEXT,height: 1.2)),
          TextSpan(text: 'For these queries we show charts that will illustrate some statistics of the retrieved data.\n'
              , style: TextStyle(fontWeight: FontWeight.normal,fontSize: constants.SIZE_TEXT,height: 1.2)),
          TextSpan(text: 'We also provide an Input-Box where you can type your own queries. For these you will simply see a tabular-like result containing all the matches.'
              , style: TextStyle(fontWeight: FontWeight.normal,fontSize: constants.SIZE_TEXT,height: 1.2)),
        ],
      ),
    );
  }
}