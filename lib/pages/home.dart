import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final CollectionReference fetchData = FirebaseFirestore.instance.collection('courses');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('extend',
        style: TextStyle(
            fontSize: 25,
            color: Colors.cyan,
            shadows: [
              Shadow(
                offset: const Offset(0, 4),
                blurRadius: 4,
                color: Colors.black.withOpacity(0.25)
              )
            ],
            ),
            ),
        centerTitle: true,
      ),
      body: StreamBuilder(stream: fetchData.snapshots(), builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
              return Material(
                child: ListTile(
                  title: Text(documentSnapshot['Title']),
                  subtitle: Text(documentSnapshot['Description']),
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      }),
    ); //Scaffold
  }
}