import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:novelkaizen/src/widgets/capitulo_firebase_form_widget.dart';

class CapituloWidget extends StatefulWidget {
  const CapituloWidget({Key? key}) : super(key: key);

  @override
  _CapituloWidgetState createState() => _CapituloWidgetState();
}

class _CapituloWidgetState extends State<CapituloWidget> {
 final Stream<QuerySnapshot> _novelasRef =
      FirebaseFirestore.instance.collection('capitulos').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _novelasRef,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Un error ha ocurrido"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: SizedBox.square(
                  dimension: 50.0, child: CircularProgressIndicator()));
        }

        return Scaffold(
            body: snapshot.data == null
                ? const Center(
                    child: SizedBox.square(
                        dimension: 50.0, child: CircularProgressIndicator()))
                : snapshot.data!.docs.isEmpty
                    ? const Center(child: Text("No hay capitulos que mostrar"))
                    : GridView.count(
                        childAspectRatio: 0.6,
                        crossAxisCount: 2,
                      ),
            floatingActionButton: FloatingActionButton(
              elevation: 4,
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const CapituloFirebaseFormWidget(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ));
      },
    ); 
  }
}