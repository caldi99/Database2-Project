import 'package:flutter/material.dart';
import 'package:gviz/gviz.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

class GraphVisualizer{
  // Makes the http post to our GraphDB server and retrieves in JSON format the triples
  static Future<Widget> httpRequestGraphDb() async{

    final graph = Gviz();

    for (var item in [
      ["Player", 2],
      [1, 2],
      [2, 5],
      [5, 1],
      [2, 6],
      [5, 6],
      [4, 3],
      [6, 7],
      [7, 6],
      [3, 7],
      [3, 4],
    ]) {
      final from = item[0].toString();
      final to = item[1].toString();

      if (!graph.nodeExists(from)) {
        graph.addNode(from, properties: {'color': 'red','shape':'circle','style':'filled'});
      }

      graph.addEdge(from, to,properties: {'label':'ciao'});
    }





    var url = Uri.parse('https://quickchart.io/graphviz');
    var body={
      "graph": graph.toString(),
      "layout": "dot",
      "format": "svg"
    };
    String body_string=json.encode(body);
    var response = await http.post(url,
        body: body_string,
        headers: { 'Content-Type': 'application/json' }
    );
    /*print(response.body);
    String s = response.body.substring(response.body.indexOf('\n')+1);
    s = s.substring(s.indexOf('\n')+1);
    final _byteImage = Base64Decoder().convert(s);
    Widget image = Image.memory(_byteImage);
    return image;*/
    return SvgPicture.string(response.body);
  }
}

class CustomGraphView extends StatefulWidget {
  const CustomGraphView({
    super.key,
  });
  @override
  State<CustomGraphView> createState() => _CustomGraphView();
}

class _CustomGraphView extends State<CustomGraphView> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (ctx, snapshot) {
        // Checking if future is resolved or not
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: const TextStyle(fontSize: 18),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            // Extracting data from snapshot object
            final data = snapshot.data;
            return Center(
                child: data
            );
          }
        }

        // Displaying LoadingSpinner to indicate waiting state
        return const Center(
          child: CircularProgressIndicator(),
        );
      },

      // Future that needs to be resolved
      // inorder to display something on the Canvas
      future: GraphVisualizer.httpRequestGraphDb(),
    );
  }
}


