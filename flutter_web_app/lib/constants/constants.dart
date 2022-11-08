import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/src/common_modes.dart';
import 'package:highlight/highlight_core.dart';

// This is the file where constants are placed to avoid having too many constants in different files

const Color RED=Color(0xFFFD1D1D);
const Color BLUE=Color(0xFF405DE6);
const Color LIGHT_BLUE=Color(0xFF558DCA);
const Color PURPLE=Color(0xFF7F00FF);
const Color CYAN=Color(0xFF16FFFF);
const Color CYAN_GREY=Color(0xFFC8EFF9);
const double SIZE_H1=60.0;
const double SIZE_H2=30.0;
const double SIZE_TEXT=20.0;

const GRAPHDB_SERVER_ADDRESS="http://localhost:8000/repositories/CPS-NBA";
const GRAPH_HTML="http://localhost:8000/assets/assets/graph.html";

const HOME_PAGE=0;
const QUERY_PAGE_1=1;
const QUERY_PAGE_2=2;
const QUERY_PAGE_3=3;

final sparql = Mode(
    refs: {
      '~contains~0~contains~5':
      Mode(className: "comment", begin: "#", end: "\$", contains: [
        PHRASAL_WORDS_MODE,
        Mode(
            className: "doctag",
            begin: "(?:TODO|FIXME|NOTE|BUG|XXX):",
            relevance: 0)
      ]),
    },
    case_insensitive: true,
    illegal: "[<>{}*]",
    contains: [
      Mode(
          beginKeywords: "select prefix insert ask describe",
          //end: ";",
          endsWithParent: true,
          //lexemes: "[\\w\\.]+",
          lexemes: "[:^A-Za-z]+",

          keywords: {
            "keyword": "select prefix insert as order by group distinct where count from limit sum avg ask describe",
            "literal": "true false null unknown",
            "built_in":"^^xsd:string ^^xsd:integer ^^xsd:date ^^xsd:dateTime ^^xsd:boolean ^^xsd:integer ^^xsd:float ^^xsd:double ^^xsd:decimal"
          },
          contains: [
            Mode(
                className: "string",
                begin: "'",
                end: "'",
                contains: [Mode(begin: "''")]),
            Mode(
                className: "string",
                begin: "\"",
                end: "\"",
                contains: [Mode(begin: "\"\"")]),
            Mode(className: "string", begin: "`", end: "`"),
            C_NUMBER_MODE,
            C_BLOCK_COMMENT_MODE,
            Mode(ref: '~contains~0~contains~5'),
            HASH_COMMENT_MODE
          ]),
      C_BLOCK_COMMENT_MODE,
      Mode(ref: '~contains~0~contains~5'),
      HASH_COMMENT_MODE
    ]);


//OTHER CONSTANTS
const TOP = "TOP";
const BOTTOM = "BOTTOM";
const SCROLLCONTROLLER_POSITION_PIXELS = 150;

//STYLE QUERIES
const BLOCK_PAGES_TITLE_STYLE_PARAGRAPH = TextStyle(fontWeight: FontWeight.bold, fontSize: SIZE_H2, height: 3);
const BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH = TextStyle(fontWeight: FontWeight.normal, fontSize: SIZE_TEXT, height: 1.2);
const BLOCK_PAGES_PADDING_PADDING_PROPRIETY = EdgeInsets.only(left: 150,right: 150,top: 20,bottom: 20);
const PAGE_PADDING_PADDING_PROPRIETY =  EdgeInsets.only(left: 20,right: 20);
const SIZED_BOX_BLOCK = SizedBox(height: 150);
const BLOCK_PAGES_CONTAINER_PADDING_PROPRIETY = EdgeInsets.all(20);
var BLOCK_PAGES_CONTAINER_DECORATION_PROPRIETY = BoxDecoration(shape: BoxShape.rectangle,color: Colors.white,
    borderRadius: BorderRadius.circular(30),
    boxShadow:[BoxShadow(color: Colors.grey.withOpacity(0.8),spreadRadius: 1,blurRadius: 8,offset: Offset(0, 3))]);
const BLOCK_PAGES_LINK_STYLE = TextStyle(color: RED,fontWeight: FontWeight.normal,fontSize: SIZE_TEXT,height: 2);
const BLOCK_PAGES_HEADER_COLUMN_STYLE = TextStyle(fontWeight: FontWeight.bold, fontSize: SIZE_TEXT);
const BLOCK_PAGES_CONTENT_CELL_STYLE = TextStyle(fontSize: SIZE_TEXT);

//QUERIES
const FRANCESCO_QUERY_1 = """PREFIX base: <https://www.dei.unipd.it/Database2/CPS-NBA/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
SELECT ?matchDate ?pts WHERE {
        ?person base:wasPlayer ?player ;
        base:name "LeBron James"^^xsd:string .
        ?player base:appearsIn ?appearance .
        ?appearance base:pts ?pts ;
                base:refersTo ?game .
        ?game base:matchDate ?matchDate .
        FILTER( ?matchDate >= "2017-10-01"^^xsd:date && ?matchDate <= "2018-07-31"^^xsd:date) .
}""";
const FRANCESCO_QUERY_2 = """PREFIX base: <https://www.dei.unipd.it/Database2/CPS-NBA/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
SELECT (SUM(?minutes) AS ?totalMinutesPlayer) (SUM(?seconds) AS ?totalSecondsPlayer) ?name WHERE {
        ?player base:playedFor ?club ;
                base:appearsIn ?appearance ;
                base:startYear "2006"^^xsd:gYear ;
                base:endYear "2007"^^xsd:gYear ;
                base:represents ?person .
        ?person base:name ?name .
        ?club base:nickname "Bulls"^^xsd:string .
        ?appearance base:minutes ?minutes ;
                base:seconds ?seconds .	
} GROUP BY (?name)""";
const ANDREA_QUERY_1 = """PREFIX base: <https://www.dei.unipd.it/Database2/CPS-NBA/>
SELECT ?name ( SUM(?pts) AS ?points ) WHERE {
        ?person base:wasPlayer ?player ;
                base:name ?name .
        ?player base:appearsIn ?appearance .
        ?appearance base:pts ?pts .
} GROUP BY (?name)
ORDER BY DESC (?points)
LIMIT 10""";
const ANDREA_QUERY_2 = """PREFIX base: <https://www.dei.unipd.it/Database2/CPS-NBA/>
SELECT ?name ?capacity ?numberOfGames WHERE{
        ?arena base:name ?name ;
                base:capacity ?capacity .
        {
                SELECT ?arena ( COUNT(?game) AS ?numberOfGames ) WHERE {
                          ?game base:hasHomeClub ?club .
                          ?club base:hasStadium ?arena .   
                } GROUP BY ?arena
        }
} ORDER BY DESC (?numberOfGames)""";

//TABLE COLUMN NAME
const TABLE_COLUMN_NAME_QUERY2_FRANCESCO = ['Name','Time Played'];

