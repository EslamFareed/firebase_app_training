import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataBaseScreen extends StatelessWidget {
  const DataBaseScreen({super.key});

  getData() {
    // States 
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      print(event.size);
    });
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Base"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    List<Map<String, dynamic>> data = [];
                    for (var element in snapshot.data!.docs) {
                      data.add(element.data());
                    }

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(data[index]["name"]),
                          subtitle: Text(data[index]["phone"]),
                          trailing: Text("${data[index]["age"]}"),
                        );
                      },
                      itemCount: data.length,
                    );
                  }
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  var data = await FirebaseFirestore.instance
                      .collection('users')
                      .get();

                  for (var element in data.docs) {
                    print(element.id);
                    print(element.data());
                  }
                },
                child: const Text('Get All'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var data = await FirebaseFirestore.instance
                      .collection('users')
                      .doc("qJ2PXIFmxjJ2PQX6z4tx")
                      .collection('images')
                      .get();
                  for (var element in data.docs) {
                    print(element.id);
                    print(element.data());
                  }
                  // print(data.data());
                },
                child: const Text('Get Item'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var ref =
                      await FirebaseFirestore.instance.collection('users').add({
                    "name": "Mohamed",
                    "age": 15,
                    "phone": "+20111111111",
                  });

                  print(ref.id);
                },
                child: const Text('Add Item'),
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc("WR4DLLF1KHRXilYUCQjq")
                      .set({
                    "age": 25,
                    "phone": "+20111111111",
                    "name": "Mohamed"
                  });
                },
                child: const Text('Update Item'),
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc('qJ2PXIFmxjJ2PQX6z4tx')
                      .delete();
                },
                child: const Text('Delete Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



//! Insert 3 Products
//! ListView