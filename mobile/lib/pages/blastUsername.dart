// ignore_for_file: file_names

import 'package:flutter/material.dart';

class UsernameBlastPage extends StatelessWidget {
  const UsernameBlastPage({Key? key}) : super(key: key);

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
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                )),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: const Text(
              "Blast With Username",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(36, 83, 83, 1)),
            ),
          ),
        ],
      )
    ]))));
  }
}
