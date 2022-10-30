import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_web_app/constants.dart' as constants;

// This is the file where all the texts in our web-app should be placed
class TitleAndDescription extends StatelessWidget {
  const TitleAndDescription({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(

      text: TextSpan(
        text: 'NBA-CPS Ontology\n',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: constants.SIZE_H1,
        ),
        children: <TextSpan>[
          const TextSpan(text: 'This is a Web-App that can be used to make SPARQL queries to the NBA Ontology we created.\n', style: TextStyle(fontWeight: FontWeight.normal,fontSize: constants.SIZE_TEXT,height: 2)),
          const TextSpan(text: 'Our aim is firstly to provide here an insight of the Ontology making a visual graph representing the classes and their properties and relationships.', style: TextStyle(fontWeight: FontWeight.normal,fontSize: constants.SIZE_TEXT,height: 1.2)),
          const TextSpan(text: 'We also make here available a set of queries that we thought to be valuable. For these queries it is possible to visualize some charts.', style: TextStyle(fontWeight: FontWeight.normal,fontSize: constants.SIZE_TEXT,height: 1.2)),
          const TextSpan(text: 'Finally, we implemented a Text-Box where you can type your query and view the results in tabular form.\n', style: TextStyle(fontWeight: FontWeight.normal,fontSize: constants.SIZE_TEXT,height: 1.2)),
          const TextSpan(text: 'The data used are provided by Kaggle. You can download the .csv files by clicking the following URLs:\n', style: TextStyle(fontWeight: FontWeight.normal,fontSize: constants.SIZE_TEXT,height: 1.2)),
          TextSpan(
            text: 'NBA Players\n',
            style: const TextStyle(color: Colors.blue,fontWeight: FontWeight.normal,fontSize: constants.SIZE_TEXT,height: 2),
            recognizer: TapGestureRecognizer()
              ..onTap = () { launchUrl(Uri.parse('https://www.kaggle.com/datasets/justinas/nba-players-data'));
              },
          ),
          TextSpan(
            text: 'NBA games data\n',
            style: const TextStyle(color: Colors.blue,fontWeight: FontWeight.normal,fontSize: constants.SIZE_TEXT,height: 2),
            recognizer: TapGestureRecognizer()
              ..onTap = () { launchUrl(Uri.parse('https://www.kaggle.com/datasets/nathanlauga/nba-games'));
              },
          ),

        ],
      ),
    );
  }
}