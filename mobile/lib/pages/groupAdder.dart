import 'package:flutter/material.dart';

class GroupAdderPage extends StatelessWidget {
  const GroupAdderPage({Key? key}) : super(key: key);

  static const List<String> _kOptions = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];
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
                "Group Adder",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(36, 83, 83, 1)),
              ),
            ),
          ],
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return _kOptions.where((String option) {
                  return option.contains(textEditingValue.text.toLowerCase());
                });
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted) {
                return TextField(
                  decoration: const InputDecoration(
                      fillColor: Colors.cyan,
                      focusColor: Colors.cyan,
                      iconColor: Colors.cyan,
                      prefixIconColor: Colors.cyan,
                      suffixIconColor: Colors.cyan,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan)),
                      labelText: 'Select Group to Scrape From',
                      suffixIcon: Icon(Icons.search)),
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                );
              },
              onSelected: (String selection) {
                debugPrint('You just selected $selection');
              },
            )),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
                fillColor: Colors.cyan,
                focusColor: Colors.cyan,
                iconColor: Colors.cyan,
                prefixIconColor: Colors.cyan,
                suffixIconColor: Colors.cyan,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan)),
                labelText: 'Enter Group/Channel Link',
                suffixIcon: Icon(Icons.link)),
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
                fillColor: Colors.cyan,
                focusColor: Colors.cyan,
                iconColor: Colors.cyan,
                prefixIconColor: Colors.cyan,
                suffixIconColor: Colors.cyan,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan)),
                labelText: 'Number of users to add',
                suffixIcon: Icon(Icons.numbers)),
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          child: Row(
            children: [
              Icon(
                Icons.help_outline,
                color: Colors.cyan.shade800,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Learn how this works ?",
                style: TextStyle(color: Colors.cyan.shade800, fontSize: 18),
              ),
            ],
          ),
          padding: EdgeInsets.all(10),
          alignment: Alignment.topLeft,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/home");
            },
            child: Container(
              child: const Text(
                "Invite Members",
                style: TextStyle(fontSize: 20),
              ),
            ),
            style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(
                    const Size.fromHeight(50)), // NEW

                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.cyan.shade700),
                textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
                  color: Colors.black,
                ))),
          ),
        )
      ])),
    ));
  }
}
