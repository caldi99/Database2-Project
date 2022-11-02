import 'package:http/http.dart' as http;
import 'dart:convert';
class QueryHandler{

  // Makes the http post to our GraphDB server and retrieves in JSON format the triples
  static httpRequestGraphDb(String query, bool infer, bool sameAS,[limit=1001,offset=0]) async{
    query="select * where { ?s ?p ?o .} limit 100";
    var url = Uri.parse('http://localhost:7270/repositories/pokemon');

    var response = await http.post(url,
        body: {
          'query': query,
          'infer': infer.toString(),
          'sameAs': sameAS.toString(),
          'limit': limit.toString(),
          'offset': offset.toString()
        },
        headers: {
          'Accept':"application/x-sparqlstar-results+json, application/sparql-results+json;q=0.9, */*;q=0.8",
          'Content-Type':"application/x-www-form-urlencoded; charset=UTF-8"
        }
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    final body = json.decode(response.body);
    return body;
  }
}