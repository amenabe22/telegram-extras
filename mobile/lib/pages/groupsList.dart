import 'package:extras/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GroupsList extends StatefulWidget {
  const GroupsList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<GroupsList> createState() => _GroupsListState();
}

class _GroupsListState extends State<GroupsList> {
  final String fetchMembers = """ 
    query {
      fetchMembers{
        id
        title
      }
    } """;

  final scrapeFromGroup = """ mutation {
    scrapeFromGroup(id: 1355338176) {
      downloadPath
    }
  }
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: IconButton(
                      onPressed: () => {Navigator.pushNamed(context, "/home")},
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30,
                      )),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: const Text(
                    "My Groups & Channels",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(36, 83, 83, 1)),
                  ),
                ),
              ],
            ),
            Query(
                options: QueryOptions(
                  document: gql(fetchMembers),
                ),
                builder: (QueryResult result, {refetch, FetchMore? fetchMore}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return Container(
                        padding: EdgeInsets.all(20),
                        child: Center(
                            child: Column(
                          children: const [
                            SizedBox(
                              height: 100,
                            ),
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Loading your telegram groups",
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ))
                        //Text("Loading Your Telegram Groups ...")
                        );
                  }
                  final List members = result.data?["fetchMembers"];

                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ListView.builder(
                            itemCount: members.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                  child: ListTile(
                                      title: Text(members[index]['title']),
                                      subtitle: Text("Sub title text"),
                                      trailing: Mutation(
                                          options: MutationOptions(
                                            document: gql(
                                                scrapeFromGroup), // this is the mutation string you just created
                                          ),
                                          builder: (RunMutation runMutation,
                                              QueryResult? result) {
                                            if (result?.isLoading ?? false) {
                                              print("Downloading Progress");
                                            }
                                            if (!(result?.hasException ??
                                                false)) {
                                              print(result
                                                      ?.data?["scrapeFromGroup"]
                                                  ["downloadPath"]);
                                              const str = "https://google.com";
                                              // "http://192.168.1.6:8000/media/members_export/coders-needed.csv";
                                              launch(
                                                str,
                                                // result?.data?["scrapeFromGroup"]
                                                // ["downloadPath"]!,
                                                forceSafariVC: false,
                                                universalLinksOnly: true,
                                              );
                                            }
                                            return IconButton(
                                              onPressed: () => runMutation({}),
                                              icon: Icon(Icons.download),
                                            );
                                          })));
                            }),
                      ],
                    ),
                  );
                })
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        elevation: 30,
        backgroundColor: Colors.cyan.shade500,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
