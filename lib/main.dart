
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './GraphGLConfiguration.dart';
import './services/api.services.dart';

import './views/InstructionsPage.dart';

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

void main() => runApp(
  GraphQLProvider(
    client: graphQLConfiguration.client,
    child: MyApp(),
  )
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Flutter Demo Home Page'),

    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[

          Query(
            options: QueryOptions(
              documentNode: gql(GET_BOOK),
              variables: {
                'imgBinary': IMG_DATA
              }
            ),
            builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {

              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.loading) {
                return Text('loading');
              }
              

              return Text(result.data.toString());
            }

          )
        ]
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
