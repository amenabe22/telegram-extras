import 'package:extras/models/home.dart';
import 'package:flutter/material.dart';

class MainHome extends StatelessWidget {
  const MainHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = [
      {
        "title": "My Groups",
        "link": "/list",
        "icon": Icons.people_alt_outlined,
        "color": Colors.teal
      },
      {
        "title": "Blast Message",
        "link": "/blast",
        "icon": Icons.rocket_outlined,
        "color": Colors.amber
      },
      {
        "title": "Group Adder",
        "link": "/groupadder",
        "icon": Icons.group_add,
        "color": Colors.amber
      },
      {
        "title": "Tips & Trics",
        "link": "/tips",
        "icon": Icons.tips_and_updates,
        "color": Colors.amber
      },
    ];
    List<HomeCards> models =
        data.map((Map item) => HomeCards.fromJson(item)).toList();

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        alignment: Alignment.center,
                        child: const Text(
                          "Telegram Extras",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(36, 83, 83, 1)),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: GridView.builder(
                      itemCount: models.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 3
                            : 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: (2 / 1),
                      ),
                      itemBuilder: (
                        context,
                        index,
                      ) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(models[index].link);
                          },
                          child: Card(
                            elevation: 0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey, width: .2),
                                borderRadius: BorderRadius.circular(8.0)),
                            child: InkWell(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Icon(
                                      models[index].icon,
                                      size: 40,
                                      color: models[index].color,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      models[index].title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(18),
                      child: const Text("Recnt Actions",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(36, 83, 83, 1)))),
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("First $index"),
                        hoverColor: Colors.red,
                        leading: Icon(
                          Icons.add_box_rounded,
                          size: 35,
                          color: Colors.teal.shade300,
                        ),
                        subtitle: Text("action details"),
                        onTap: () => {},
                      );
                    },
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: 10,
                  )
                  // Text("Second block")
                ],
              ),
            ),
          ),
        ));
  }
}
