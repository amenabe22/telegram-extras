import 'package:extras/pages/home.dart';
import 'package:flutter/material.dart';

class HomeCards {
  final String title;
  final String link;
  final IconData icon;
  final Color color;

  HomeCards(this.title, this.link, this.icon, this.color);
  HomeCards.fromJson(Map<dynamic, dynamic> json)
      : title = json["title"],
        icon = json["icon"],
        color = json["color"],
        link = json["link"];
  Map<String, dynamic> toJson() =>
      {'title': title, 'link': link, 'icon': icon, 'color': color};
}
