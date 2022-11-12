import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/src/common_modes.dart';
import 'package:highlight/highlight_core.dart';

// This is the file where constants are placed to avoid having too many constants in different files

//COLORS
const Color RED = Color(0xFFFD1D1D);
const Color BLUE = Color(0xFF405DE6);
const Color LIGHT_BLUE = Color(0xFF558DCA);
const Color PURPLE = Color(0xFF7F00FF);
const Color CYAN = Color(0xFF16FFFF);
const Color CYAN_GREY = Color(0xFFC8EFF9);

//SIZES
const double SIZE_H1 = 60.0;
const double SIZE_H2 = 30.0;
const double SIZE_TEXT = 20.0;
const IFRAME_HEIGHT = "700";
const IFRAME_WIDTH = "900";
const CONTAINER_IFRAME_HEIGHT = 720.0;
const CONTAINER_IFRAME_WIDTH = 920.0;

//URLS
const GRAPHDB_SERVER_ADDRESS = "http://localhost:8000/repositories/CPS-NBA";
const GRAPH_HTML = "http://localhost:8000/assets/assets/graph.html";

//PAGE INDEXES
const HOME_PAGE_INDEX = 0;
const ANDREA_QUERY_PAGE_INDEX = 1;
const FRANCESCO_QUERY_PAGE_INDEX = 2;
const HARJOT_QUERY_PAGE_INDEX = 3;

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
            "keyword":
                "select prefix insert as order by group distinct where count from limit sum avg ask describe",
            "literal": "true false null unknown",
            "built_in":
                "^^xsd:string ^^xsd:integer ^^xsd:date ^^xsd:dateTime ^^xsd:boolean ^^xsd:integer ^^xsd:float ^^xsd:double ^^xsd:decimal"
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
const BLOCK_PAGES_TITLE_STYLE_PARAGRAPH =
    TextStyle(fontWeight: FontWeight.bold, fontSize: SIZE_H2, height: 3);
const BLOCK_PAGES_CONTENT_STYLE_PARAGRAPH =
    TextStyle(fontWeight: FontWeight.normal, fontSize: SIZE_TEXT, height: 1.2);
const BLOCK_PAGES_PADDING_PADDING_PROPRIETY =
    EdgeInsets.only(left: 150, right: 150, top: 20, bottom: 20);
const PAGE_PADDING_PADDING_PROPRIETY = EdgeInsets.only(left: 20, right: 20);
const SIZED_BOX_BLOCK = SizedBox(height: 150);
const BLOCK_PAGES_CONTAINER_PADDING_PROPRIETY = EdgeInsets.all(20);
var BLOCK_PAGES_CONTAINER_DECORATION_PROPRIETY = BoxDecoration(
    shape: BoxShape.rectangle,
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(
          color: Colors.grey.withOpacity(0.8),
          spreadRadius: 1,
          blurRadius: 8,
          offset: Offset(0, 3))
    ]);
const BLOCK_PAGES_LINK_STYLE = TextStyle(
    color: RED, fontWeight: FontWeight.normal, fontSize: SIZE_TEXT, height: 2);
const BLOCK_PAGES_HEADER_COLUMN_STYLE =
    TextStyle(fontWeight: FontWeight.bold, fontSize: SIZE_TEXT);
const BLOCK_PAGES_CONTENT_CELL_STYLE = TextStyle(fontSize: SIZE_TEXT);
const BLOCK_PAGES_DESCRIPTION_AXIS_STYLE =
    TextStyle(fontSize: 13, fontWeight: FontWeight.w300);
const BLOCK_PAGES_COLUMNSERIES_BORDERRADIUS_PROPRIETY = BorderRadius.only(
    topLeft: Radius.circular(5), topRight: Radius.circular(5));
const IFRAME_STYLE_BORDER_PROPRIETY = "none";

//QUERIES
const FRANCESCO_QUERY_1 =
    """PREFIX base: <https://www.dei.unipd.it/Database2/CPS-NBA/>
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
const FRANCESCO_QUERY_2 =
    """PREFIX base: <https://www.dei.unipd.it/Database2/CPS-NBA/>
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
const ANDREA_QUERY_1 =
    """PREFIX base: <https://www.dei.unipd.it/Database2/CPS-NBA/>
SELECT ?name ( SUM(?pts) AS ?points ) WHERE {
        ?person base:wasPlayer ?player ;
                base:name ?name .
        ?player base:appearsIn ?appearance .
        ?appearance base:pts ?pts .
} GROUP BY (?name)
ORDER BY DESC (?points)
LIMIT 10""";
const ANDREA_QUERY_2 =
    """PREFIX base: <https://www.dei.unipd.it/Database2/CPS-NBA/>
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
// Harjot
const HARJOT_QUERY_1 = """
PREFIX base: <https://www.dei.unipd.it/Database2/CPS-NBA/>
SELECT ?winHome ( COUNT(?winHome) AS ?numberOfGames ) WHERE { 
	?game base:winHome ?winHome .
} GROUP BY (?winHome)
""";
const HARJOT_QUERY_2 = """
PREFIX base: <https://www.dei.unipd.it/Database2/CPS-NBA/>
PREFIX country: <https://www.dei.unipd.it/Database2/CPS-NBA/Country#>
SELECT ?clubName ( COUNT(?person) AS ?internationalPlayers ) WHERE {
  ?person base:isFrom ?country ;
	      base:wasPlayer ?player .
	?player base:playedFor ?club .
	?club base:city ?city ;
	      base:nickname ?nickname .
    FILTER (?country != country:USA)
    BIND(concat(?nickname, ", ",?city) as ?clubName)
} GROUP BY ?clubName
ORDER BY DESC(?internationalPlayers)""";
const HARJOT_QUERY_3 = """
PREFIX base: <https://www.dei.unipd.it/Database2/CPS-NBA/>
SELECT ?season ?winClub1 (COUNT(?winClub1) AS ?totalWin) WHERE{
    {
    ?club1 base:nickname ?clubname1.
    ?club2 base:nickname ?clubname2.
    ?game 
        base:hasHomeClub ?club1;
		base:hasAwayClub ?club2;
  		base:winHome ?winClub1;
    	base:matchDate ?matchDate.
    FILTER REGEX(?clubname1,"Bulls")
    FILTER REGEX(?clubname2, "Heat")
    }UNION{
    ?club1 base:nickname ?clubname1.
    ?club2 base:nickname ?clubname2.
    ?game 
		base:hasHomeClub ?club1;
		base:hasAwayClub ?club2;
  		base:winHome ?winHome;
    	base:matchDate ?matchDate.
    BIND(IF(?winHome <= 0,1,0) as ?winClub1).
    FILTER REGEX(?clubname1,"Heat")
    FILTER REGEX(?clubname2, "Bulls")
    }
    BIND(IF(month(?matchDate)<8,year(?matchDate)-1,year(?matchDate)) as ?season)
}
GROUP BY ?season ?winClub1
ORDER BY ASC (?season)
LIMIT 100
""";
const HARJOT_QUERY_4 = """
PREFIX base: <https://www.dei.unipd.it/Database2/CPS-NBA/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX country: <https://www.dei.unipd.it/Database2/CPS-NBA/Country#>
SELECT ?winnerTeam ?playerName ?country WHERE
{
    ?person base:wasPlayer ?player;
            base:name ?playerName;
            base:isFrom ?countryURI.
    ?countryURI base:name ?country.
	?player base:playedFor ?club .
	?club base:nickname ?winnerTeam.
    {
        SELECT DISTINCT ?playerMinGrater0 WHERE 
        {
        	?playerMinGrater0 base:appearsIn ?appearance ;
                           	  base:startYear "2015"^^xsd:gYear .
            ?appearance base:minutes ?minutes ;
            			base:seconds ?seconds .
            ?person base:isFrom ?country ;
            		base:wasPlayer ?playerMinGrater0 .
			?country base:name ?countryName .			
            FILTER ((?minutes > 0 || ?seconds > 0) && ?country != country:USA)           
        }
    }
	FILTER(?player = ?playerMinGrater0)
    FILTER(?winnerTeam = ?nickname)
    {
        SELECT ?nickname WHERE {
        {
            SELECT ?nickname (SUM(?wins) AS ?totalWins) WHERE{
                {
                    SELECT ?nickname (SUM(?winHome) AS ?wins) WHERE {
                        ?game base:hasHomeClub ?homeClub ;
                              base:matchDate ?matchDate ;
                              base:winHome ?winHome .
                        ?homeClub base:nickname ?nickname .
                        FILTER(?matchDate >= "2015-10-27"^^xsd:date && ?matchDate <= "2016-06-12"^^xsd:date)
                    }GROUP BY(?nickname)
                }
                UNION
                {
                    SELECT ?nickname (SUM(1 - ?winHome) AS ?wins) WHERE {
                        ?game base:hasAwayClub ?awayClub ;
                              base:matchDate ?matchDate ;
                              base:winHome ?winHome .
                        ?awayClub base:nickname ?nickname .
                        FILTER(?matchDate >= "2015-10-27"^^xsd:date && ?matchDate <= "2016-06-12"^^xsd:date)
                    }GROUP BY(?nickname)
                }
            }GROUP BY(?nickname)
        }
        FILTER (?totalWins = ?max)
        {
            SELECT (MAX(?totalWins) as ?max){
                SELECT ?nickname (SUM(?wins) AS ?totalWins) WHERE{
                    {
                        SELECT ?nickname (SUM(?winHome) AS ?wins) WHERE {
                            ?game base:hasHomeClub ?homeClub ;
                                  base:matchDate ?matchDate ;
                                  base:winHome ?winHome .
                            ?homeClub base:nickname ?nickname .
                            FILTER(?matchDate >= "2015-10-27"^^xsd:date && ?matchDate <= "2016-06-12"^^xsd:date)
                        }GROUP BY(?nickname)
                    }
                    UNION
                    {
                        SELECT ?nickname (SUM(1 - ?winHome) AS ?wins) WHERE {
                            ?game base:hasAwayClub ?awayClub ;
                                  base:matchDate ?matchDate ;
                                  base:winHome ?winHome .
                            ?awayClub base:nickname ?nickname .
                            FILTER(?matchDate >= "2015-10-27"^^xsd:date && ?matchDate <= "2016-06-12"^^xsd:date)
                        }GROUP BY(?nickname)
                    }
                }GROUP BY(?nickname)
            }
        }	
		}
    }
}

LIMIT 100
""";

//TABLE COLUMN NAME
const TABLE_COLUMNS_NAME_QUERY2_FRANCESCO = ['Name', 'Time Played'];
const TABLE_COLUMNS_NAME_QUERY2_HARJOT = ['Club Name', '# International Players'];
const TABLE_COLUMNS_NAME_QUERY4_HARJOT = ['Club Name', "International player Name", 'Country'];
