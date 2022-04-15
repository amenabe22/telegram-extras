import 'package:extras/pages/Tips.dart';
import 'package:extras/pages/blastMessage.dart';
import 'package:extras/pages/blastUsername.dart';
import 'package:extras/pages/groupAdder.dart';
import 'package:extras/pages/groupsList.dart';
import 'package:extras/pages/home.dart';
import 'package:extras/pages/MainHome.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const Home());

      case "/home":
        return MaterialPageRoute(builder: (_) => const MainHome());

      case "/tips":
        return MaterialPageRoute(builder: (_) => const TipsPage());

      case "/list":
        return MaterialPageRoute(
            builder: (_) => const GroupsList(title: "Telegram Extras"));

      case "/blast":
        return MaterialPageRoute(builder: (_) => const BlastMessagePage());

      case "/groupadder":
        return MaterialPageRoute(builder: (_) => const GroupAdderPage());

      case "/blastuname":
        return MaterialPageRoute(builder: (_) => const UsernameBlastPage());

      default:
        return _errorRoutes();
    }
  }

  static Route<dynamic> _errorRoutes() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("error"),
        ),
        body: const Center(
          child: Text("Error"),
        ),
      );
    });
  }
}
