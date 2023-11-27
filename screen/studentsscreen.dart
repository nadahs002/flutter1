import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:tp7_test/entities/classe.dart';
import 'package:tp7_test/entities/student.dart';
import 'package:tp7_test/service/studentservice.dart';
import 'package:tp7_test/template/navbar.dart';

import '../template/dialog/studentdialog.dart';

class StudentScreen extends StatefulWidget {
  Classe? classe;
  StudentScreen({super.key, this.classe});

  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  double _currentFontSize = 0;
  String nomClasse = "tous les étudiants";
  refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.classe != null) {
      nomClasse = "étudiants ${widget.classe!.nomClass}";
    }
  }

  getStudentList() {
    if (widget.classe != null) {
      return getStudentsByClasseId(widget.classe!.codClass);
    } else {
      return getAllStudent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getStudentList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data.isEmpty) {
          return Scaffold(
            appBar: NavBar(nomClasse),
            body: Center(
              child: Text(
                "Aucun étudiant trouvé",
                style: TextStyle(fontSize: 20),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.purpleAccent,
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddStudentDialog(
                        notifyParent: refresh,
                      );
                    });
              },
              child: Icon(Icons.add),
            ),
          );
        } else {
          return Scaffold(
            appBar: NavBar(nomClasse),
            body: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Slidable(
                  key: Key((snapshot.data[index]['id']).toString()),
                  startActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          AlertDialog alert = AlertDialog(
                            title: Text("Supprimer"),
                            content:
                                Text("Voulez-vous supprimer cet étudiant ?"),
                            actions: [
                              TextButton(
                                child: Text("Oui"),
                                onPressed: () async {
                                  await deleteStudent(
                                      snapshot.data[index]['id']);
                                  setState(() {
                                    snapshot.data.removeAt(index);
                                  });
                                },
                              ),
                              TextButton(
                                child: Text("Non"),
                                onPressed: () {
                                  BuildContext dialogContext = context;
                                  Navigator.of(dialogContext).pop();
                                },
                              ),
                            ],
                          );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        },
                        backgroundColor: Color.fromARGB(255, 202, 33, 33),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'delete',
                        spacing: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text("Nom et Prénom :" +
                            snapshot.data[index]['nom'] +
                            " " +
                            snapshot.data[index]['prenom']),
                        subtitle: Text(
                          'Date de Naissance :' +
                              DateFormat("dd-MM-yyyy").format(DateTime.parse(
                                  snapshot.data[index]['dateNais'])),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          alignment: Alignment.centerRight,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AddStudentDialog(
                                      notifyParent: refresh,
                                      student: Student(
                                        snapshot.data[index]['dateNais'],
                                        snapshot.data[index]['nom'],
                                        snapshot.data[index]['prenom'],
                                        Classe(
                                          snapshot.data[index]['classe']
                                              ['nbreEtud'],
                                          snapshot.data[index]['classe']
                                              ['nomClass'],
                                          snapshot.data[index]['classe']
                                              ['codClass'],
                                        ),
                                        snapshot.data[index]['id'],
                                      ));
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.purpleAccent,
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddStudentDialog(
                        notifyParent: refresh,
                      );
                    });
              },
              child: Icon(Icons.add),
            ),
          );
        }
      },
    );
  }
}
