import 'package:extras/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfiguration {
  static final httpLink = HttpLink('http://192.168.1.6:8000/graphql');

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    ),
  );

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );
  }
}

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

void main() {
  runApp(GraphQLProvider(
      client: graphQLConfiguration.client,
      child: CacheProvider(child: MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: graphQLConfiguration.client,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Telegram Extras',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // home: const MyHomePage(title: 'Telegram Extras'),
          initialRoute: "/",
          onGenerateRoute: RouteGenerator.generateRoute,
        ));
  }
}
