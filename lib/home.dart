import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isUpdate = false;
  String tileId = '';

  // Textediting Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  // Custombutomsheet function
  custombuttomsheet() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController),
              TextField(controller: contactController),
              TextField(controller: countryController),
              SizedBox(height: 21),
              ElevatedButton(
                onPressed: () {
                  if (isUpdate) {
                    updateUser();
                  } else {
                    addUser();
                  }
                },
                child: Text(isUpdate ? "update" : "add"),
              ),
            ],
          ),
        );
      },
    );
  }

  // Add Users button function
  addUser() {
    FirebaseFirestore.instance
        .collection('user')
        .add({
          "name": nameController.text,
          "contact": contactController.text,
          "country": countryController.text,
        })
        .then((Value) => print("$Value Done"))
        .onError((error, stackTrace) => print("$error"));
    nameController.clear();
    contactController.clear();
    countryController.clear();
  }

  // update User
  updateUser() {
    FirebaseFirestore.instance
        .collection('user')
        .doc(tileId)
        .update({
          'name': nameController.text,
          'contact': contactController.text,
          "country": countryController.text,
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          custombuttomsheet();
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('user').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data!.docs.toString());
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot abc = snapshot.data!.docs[index];
                print(abc.id);
                return ListTile(
                  title: Text("${abc['name']}"),
                  subtitle: Text(
                    "${abc['contact']} "
                    "|"
                    "  ${abc['country']}",
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            isUpdate = true;
                            nameController.text = abc['name'];
                            contactController.text = abc['contact'];
                            countryController.text = abc['country'];
                            tileId = abc.id;
                          });
                          custombuttomsheet();
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('user')
                              .doc(abc.id)
                              .delete();
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
