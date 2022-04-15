import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class TipsPage extends StatefulWidget {
  const TipsPage({Key? key}) : super(key: key);

  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  @override
  Widget build(BuildContext context) {
    ScrollController? _controller;

    @override
    void initState() {
      _controller = ScrollController();
      // TODO: implement initState
      super.initState();
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: rootBundle.loadString("assets/test.md"),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: IconButton(
                                onPressed: () =>
                                    {Navigator.pushNamed(context, "/home")},
                                icon: Icon(
                                  Icons.arrow_back,
                                  size: 30,
                                )),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            alignment: Alignment.center,
                            child: const Text(
                              "Tips and Trics",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(36, 83, 83, 1)),
                            ),
                          ),
                        ],
                      ),
                      Markdown(
                        shrinkWrap: true,
                        data: snapshot.data!,
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        )
        // SafeArea(
        //     child: Center(
        //   child: Column(children: [
        //     const SizedBox(
        //       height: 20,
        //     ),
        //     Row(
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.only(left: 15),
        //           child: IconButton(
        //               onPressed: () => {Navigator.pushNamed(context, "/home")},
        //               icon: const Icon(
        //                 Icons.arrow_back,
        //                 size: 30,
        //               )),
        //         ),
        //         Container(
        //           padding: const EdgeInsets.all(20),
        //           alignment: Alignment.center,
        //           child: const Text(
        //             "Tips & Triks",
        //             style: TextStyle(
        //                 fontSize: 25,
        //                 fontWeight: FontWeight.w600,
        //                 color: Color.fromRGBO(36, 83, 83, 1)),
        //           ),
        //         ),
        //       ],
        //     ),
        //     const Markdown(
        //       // controller: _controller,
        //       // selectable: true,
        //       data: 'Insert emoji here😀 ',
        //     ),
        //   ]),
        // ))
        );
  }
}
