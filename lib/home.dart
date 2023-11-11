import 'package:flutter/material.dart';

import 'custom_search_delegate.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _data = 'Loading...';
  String name = '';
  String maiorCotacao ='';
  String menorCotacao = '';
  bool isLoading = true;
  final List<String> moedas = [

    'Bitcoin',
    'Dirham dos Emirados',
    'Dólar Americano',
    'Dólar Canadense',
    'teste erro'

  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Demo'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(moedas),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: moedas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(moedas[index]),
            onTap: (){
              showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(moedas)
              );
            },
          );
        },
      ),
    );
  }
}