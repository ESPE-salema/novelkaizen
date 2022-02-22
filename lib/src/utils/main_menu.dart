import 'package:flutter/material.dart';
import 'package:novelkaizen/src/widgets/biblioteca_widget.dart';
import 'package:novelkaizen/src/widgets/descubrir_widget.dart';
import 'package:novelkaizen/src/widgets/genero_widget.dart';
import 'package:novelkaizen/src/widgets/novela_firebase_widget.dart';
import 'package:novelkaizen/src/widgets/yo_widget.dart';

class ItemMenu {
  String title;
  IconData icon;
  ItemMenu(this.icon, this.title);
}

List<ItemMenu> menuOptions = [
  ItemMenu(Icons.home, "Inicio"),
  ItemMenu(Icons.filter_none, "Género"),
  ItemMenu(Icons.explore, "Descubrir"),
  ItemMenu(Icons.book, "Biblioteca"),
  ItemMenu(Icons.account_circle, "Yo"),
];

List<Widget> homeWidgets = [
  const NovelaFirebaseWidget(),
  const GeneroWidget(),
  const DescubrirWidget(),
  const BibliotecaWidget(),
  const YoWidget(),
];
