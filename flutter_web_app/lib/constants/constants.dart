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

const GRAPHDB_SERVER_ADDRESS="http://localhost:7200/repositories/CSP-NBA";
const GRAPH_HTML="http://localhost:8000/assets/assets/graph.html";
const GRAPH_HTML_DEBUG="http://localhost:8000/assets/assets/graph.html";

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
          beginKeywords: "select prefix insert",
          //end: ";",
          endsWithParent: true,
          //lexemes: "[\\w\\.]+",
          lexemes: "[:^A-Za-z]+",

          keywords: {
            "keyword": "select prefix insert as order by distinct where count from limit sum avg",
            "literal": "true false null unknown",
            "built_in":"^^xsd:string ^^xsd:integer ^^xsd:dateTime ^^xsd:boolean ^^xsd:integer ^^xsd:float ^^xsd:double ^^xsd:decimal"
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

