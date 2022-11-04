import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_web_app/constants.dart' as constants;

class GraphIFrame extends StatefulWidget {
  const GraphIFrame({super.key});

  @override
  _GraphIFrame createState() => _GraphIFrame();
}

class _GraphIFrame extends State<GraphIFrame> {
  final IFrameElement _iframeElement = IFrameElement();
  late Widget _iframeWidget;


  @override
  void initState() {
    _iframeElement.height = '700';
    _iframeElement.width = '900';
    //_iframeElement.src = constants.GRAPH_HTML;
    _iframeElement.src = constants.GRAPH_HTML_DEBUG;
    _iframeElement.style.border = 'none';
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
          (int viewId) => _iframeElement,
    );

    _iframeWidget = HtmlElementView(
      key: UniqueKey(),
      viewType: 'iframeElement',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child:Container(
          height: 720,
          width: 920,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                spreadRadius: 3,
                blurRadius: 8,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: _iframeWidget,
        )
    );
  }

}
