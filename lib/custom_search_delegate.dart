import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  final List<String> items;
  String maiorCotacao = '';
  String menorCotacao = '';
  String name = '';
  bool isLoading = true;
  final coinsOptions = {
    "Dirham dos Emirados": "AED",
    "Bitcoin": "BTC",
    "Dólar Canadense" : "CAD",
    "Dólar Americano" : "USD",
    "teste erro": "err"

  };
  static const String pais = 'BRL';

  CustomSearchDelegate(this.items);

  Future<String> callAsyncFetch(String query) async {
    String? moeda = coinsOptions[query];
    String url = 'http://economia.awesomeapi.com.br/json/last/$moeda-$pais';
    print(url);

    final response = await http.get(Uri.parse(url));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      name = jsonResponse['$moeda$pais']['name'];
      maiorCotacao = formatarMoeda(jsonResponse['$moeda$pais']['high']);
      menorCotacao = formatarMoeda(jsonResponse['$moeda$pais']['low']);
      return 'Ok';
    } else {
      return 'Erro';
    }
  }

  String formatarMoeda(valor) {
    double value = double.parse(valor);
    final formatter = new NumberFormat("#,##0.00", "pt_BR");
    String newText = "R\$ " + formatter.format(value);

    return newText;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(context) {
    return FutureBuilder<String>(
        future: callAsyncFetch(query),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.toLowerCase() == 'ok') {
              return ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.currency_exchange),
                    title: Text(
                        style: TextStyle(fontWeight: FontWeight.bold),
                        name),
                  ),
                  ListTile(
                    leading: Icon(color: Colors.green, Icons.arrow_circle_up),
                    title: Text(
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maiorCotacao),
                  ),
                  ListTile(
                    leading: Icon(color: Colors.red, Icons.arrow_circle_down),
                    title: Text(menorCotacao,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              );
            } else {
              return Container(
                child:   Center(
                  child: Text(
                      'Nenhum moeda com o nome $query foi encontrada!'
                  ),
                ),
              );


            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestions = query.isEmpty
        ? []
        : items
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            // Update the search query when an option is clicked
            query = suggestions[index];

            // Close the search and display the selected item
            showResults(context);
          },
        );
      },
    );
  }
}