import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_web_app/constants.dart' as constants;
// This is the file where all the texts in our web-app should be placed

const double HEIGHT=3;


class TitleAndDescriptionParagraph extends StatelessWidget {
  const TitleAndDescriptionParagraph({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(

      text: TextSpan(
        text: 'NBA-CPS: Our Ontology\n',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: constants.SIZE_H1,
          height: HEIGHT,
        ),
        children: <TextSpan>[
          const TextSpan(text: 'This is a Web-App that can be used to make SPARQL queries to the NBA Ontology we created.\n', style: TextStyle(fontWeight: FontWeight.normal,fontSize: constants.SIZE_TEXT,height: 1.2)),
          const TextSpan(text: 'Our aim is firstly to provide here an insight of the Ontology making a visual graph representing the classes and their properties and relationships. ', style: TextStyle(fontWeight: FontWeight.normal,fontSize: constants.SIZE_TEXT,height: 1.2)),
          const TextSpan(text: 'We also make here available a set of queries that we thought to be valuable. For these queries it is possible to visualize some charts. ', style: TextStyle(fontWeight: FontWeight.normal,fontSize: constants.SIZE_TEXT,height: 1.2)),
          const TextSpan(text: 'Finally, we implemented a Text-Box where you can type your query and view the results in tabular form.\n', style: TextStyle(fontWeight: FontWeight.normal,fontSize: constants.SIZE_TEXT,height: 1.2)),
          const TextSpan(text: 'The data used are provided by Kaggle. You can download the .csv files by clicking the following URLs:\n', style: TextStyle(fontWeight: FontWeight.normal,fontSize: constants.SIZE_TEXT,height: 1.2)),


          TextSpan(
            text: '-  NBA Players\n',
            style: const TextStyle(color: constants.RED,fontWeight: FontWeight.normal,fontSize: constants.SIZE_TEXT,height: 2),
            recognizer: TapGestureRecognizer()
              ..onTap = () { launchUrl(Uri.parse('https://www.kaggle.com/datasets/justinas/nba-players-data'));
              },
          ),

          TextSpan(
            text: '-  NBA games data',
            style: const TextStyle(color: constants.RED,fontWeight: FontWeight.normal,fontSize: constants.SIZE_TEXT,height: 2),
            recognizer: TapGestureRecognizer()
              ..onTap = () { launchUrl(Uri.parse('https://www.kaggle.com/datasets/nathanlauga/nba-games'));
              },
          ),

        ],
      ),
    );
  }
}


class GraphParagraph extends StatelessWidget {
  const GraphParagraph({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(

      text: const TextSpan(
        text: 'How the Graph looks\n',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: constants.SIZE_H2,
          height: HEIGHT,
        ),
        children: <TextSpan>[
          TextSpan(text: 'Here we provide an interactive sandbox created with d3js where you can see which are our classes and their relationships:'
           , style: TextStyle(fontWeight: FontWeight.normal,fontSize: constants.SIZE_TEXT,height: 1.2)),
        ],
      ),
    );
  }
}

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