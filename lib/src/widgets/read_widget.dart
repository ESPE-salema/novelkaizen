import 'package:flutter/material.dart';
import 'package:novelkaizen/src/models/capitulo_model.dart';
import 'package:novelkaizen/src/providers/main_provider.dart';
import 'package:novelkaizen/src/theme/app_theme.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe

class ReadWidget extends StatefulWidget {
  const ReadWidget({Key? key, required this.model}) : super(key: key);
  final Capitulo model;

  @override
  State<ReadWidget> createState() => _ReadWidgetState();
}

class _ReadWidgetState extends State<ReadWidget> {
  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context, listen: true);

    return SafeArea(
        child: Scaffold(
            body: CustomScrollView(
      slivers: [
        SliverAppBar(
          iconTheme: mainProvider.mode
              ? const IconThemeData(color: Colors.black)
              : const IconThemeData(color: Palette.color),
          floating: true,
          pinned: true,
          elevation: 2,
          title: Text(widget.model.tituloCapitulo ?? ""),
        ),
      ],
    )));
  }
}
