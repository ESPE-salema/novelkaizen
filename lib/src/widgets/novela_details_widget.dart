import 'package:flutter/material.dart';
import 'package:novelkaizen/src/models/novela_model.dart';
import 'package:novelkaizen/src/theme/app_theme.dart';
import 'package:novelkaizen/src/widgets/capitulo_widget.dart';

import 'novela_details_content_widget.dart';

class NovelaDetailsWidget extends StatefulWidget {
  const NovelaDetailsWidget({Key? key, required this.novela, required this.id}) : super(key: key);
  final Novela novela;
  final String id;

  @override
  _NovelaDetailsWidgetState createState() => _NovelaDetailsWidgetState();
}

class _NovelaDetailsWidgetState extends State<NovelaDetailsWidget>
    with SingleTickerProviderStateMixin {
  final List<Tab> _tabs = <Tab>[
    const Tab(text: "Detalles"),
    const Tab(text: "Capítulos"),
  ];

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: _tabs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TabBar(
            indicatorColor: Palette.color,
            tabs: _tabs,
            controller: _tabController),
        body: TabBarView(children: [
          NovelaDetailsContentWidget(novela: widget.novela),
          CapituloWidget(id: widget.id)
        ], controller: _tabController));
  }
}
