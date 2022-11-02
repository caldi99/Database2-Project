import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class GraphClusterViewPage extends StatefulWidget {
  @override
  _GraphClusterViewPageState createState() => _GraphClusterViewPageState();
}

class _GraphClusterViewPageState extends State<GraphClusterViewPage> {
  @override
  Widget build(BuildContext context) {
    return
            Container(
              color: Colors.blue,
              height: 500,
              child: InteractiveViewer(
        minScale: 0.35,
        maxScale: 1,
        boundaryMargin: EdgeInsets.all(double.infinity),
    child: OverflowBox(
    alignment: Alignment.center,
    minWidth: 0.0,
    minHeight: 0.0,
    maxWidth: double.infinity,
    maxHeight: double.infinity,
    child: GraphView(
                    animated: true,

                      graph: graph,
                      algorithm: builder,
                      paint: Paint()
                        ..color = Colors.green
                        ..strokeWidth = 1
                        ..style = PaintingStyle.fill,
                      builder: (Node node) {
                        // I can decide what widget should be shown here based on the id
                        var a = node.key!.value as int?;
                        //if (a == 2) {
                        //  return drawnNode(a);
                        //}
                        return drawnNode(a);
                      })//),
    ))

        );
  }

  int n = 8;
  Random r = Random();

  Widget drawnNode(int? i){
    final Color c=Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: c, spreadRadius: 1),
          ],
        ),
        child: Text('Node $i')
    );
  }


  final Graph graph = Graph();
  late Algorithm builder;

  @override
  void initState() {
    final a = Node.Id(1);
    final b = Node.Id(2);
    final c = Node.Id(3);
    final d = Node.Id(4);
    final e = Node.Id(5);
    final f = Node.Id(6);
    final g = Node.Id(7);
    final h = Node.Id(8);

    graph.addEdge(a, b, paint: Paint()..color = Colors.red);
    graph.addEdge(a, c,paint: Paint()..color = Colors.green);
    graph.addEdge(a, c);
    graph.addEdge(a, d);
    graph.addEdge(c, e);
    graph.addEdge(d, f);
    graph.addEdge(f, c);
    graph.addEdge(g, c);
    graph.addEdge(h, g);

    builder = FruchtermanReingoldAlgorithm(iterations: 1000);
  }
}
