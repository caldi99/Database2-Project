import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;

class GraphIFrameBlock extends StatefulWidget {
  const GraphIFrameBlock({super.key});
  @override
  _GraphIFrame createState() => _GraphIFrame();
}

class _GraphIFrame extends State<GraphIFrameBlock> {
  //DATA MEMBERS
  final IFrameElement _iframeElement = IFrameElement();
  late Widget _iframeWidget;

  @override
  void initState() {
    _iframeElement.height = constants.IFRAME_HEIGHT;
    _iframeElement.width = constants.IFRAME_WIDTH;
    _iframeElement.src = constants.GRAPH_HTML;
    _iframeElement.style.border = constants.IFRAME_STYLE_BORDER_STYLE;
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('iframeElement', (int viewId) => _iframeElement);
    _iframeWidget = HtmlElementView(key: UniqueKey(),viewType: 'iframeElement');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child:Container(
          height: constants.CONTAINER_IFRAME_HEIGHT,
          width: constants.CONTAINER_IFRAME_WIDTH,
          decoration: constants.BLOCK_PAGES_CONTAINER_DECORATION_STYLE,
          child: _iframeWidget,
        )
    );
  }
}
