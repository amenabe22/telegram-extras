import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  const Text(
                    "Telegram Extras",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 45,
                        color: Colors.black45),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 50.0, right: 50.0, top: 20),
                    child: Text(
                      "Here goes some nice subtitle text and goes some more stuff under it",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: Colors.black45),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 40, right: 40, top: 50),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/home");
                      },
                      child: Container(
                        child: const Text(
                          "Get Started",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size.fromHeight(50)), // NEW

                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.cyan.shade700),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                              const TextStyle(
                            color: Colors.black,
                          ))),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
