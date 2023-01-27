import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_app/constants/constants.dart' as constants;

class TableBlock extends StatefulWidget {
  final tableData;
  final tableCols;
  const TableBlock({super.key,this.tableData,this.tableCols});

  @override
  _TableBlockState createState() => _TableBlockState();
}

class _TableBlockState extends State<TableBlock> {
  //DATA MEMBERS
  late List<List<String>> _tableData;
  late List<String> _tableCols;

  @override
  void initState() {
    _tableData = widget.tableData;
    _tableCols = widget.tableCols;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: constants.BLOCK_PAGES_CONTAINER_PADDING_STYLE,
        decoration: constants.BLOCK_PAGES_CONTAINER_DECORATION_STYLE,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
              columns: [
                for(var col in _tableCols) ... [
                  DataColumn(label: Expanded(child: Text(col,style: constants.BLOCK_PAGES_HEADER_COLUMN_STYLE)))
                ]
              ],
              rows: [
                for(var row in _tableData) ... [
                  DataRow(
                      cells: [
                        for(var cell in row) ... [
                          DataCell(Text(cell,style: constants.BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH))
                        ]
                      ]
                  )
                ]
              ]
          ),
        )
    );
  }
}
