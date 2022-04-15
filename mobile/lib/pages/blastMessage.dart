import 'package:extras/models/home.dart';
import 'package:flutter/material.dart';

class BlastMessagePage extends StatelessWidget {
  const BlastMessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = [
      {
        "title": "Blast By Username",
        "link": "/blastuname",
        "icon": Icons.face,
        "color": Colors.teal
      },
      {
        "title": "Blast To Private",
        "link": "/blast",
        "icon": Icons.privacy_tip_outlined,
        "color": Colors.blue.shade400
      },
      {
        "title": "Learn More",
        "link": "/help",
        "icon": Icons.help_outline_outlined,
        "color": Colors.amber
      },
    ];
    List<HomeCards> models =
        data.map((Map item) => HomeCards.fromJson(item)).toList();

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
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  )),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: const Text(
                "Send Blast Message",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(36, 83, 83, 1)),
              ),
            ),
          ],
        ),
        SizedBox(
          child: GridView.builder(
            itemCount: models.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 2
                      : 1,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(
                            models[index].icon,
                            size: 80,
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
                                fontSize: 22,
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
        )
      ])),
    ));
  }
}
