import 'package:flutter/material.dart';
import 'package:sqlite_tutorial/database_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class Contacts {
  String name = '';
  int id;

  Contacts(this.name, this.id);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nameController = TextEditingController();
  String displayText = '';
  //this displayText will take the value from the nameController
  List<Contacts> contact = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(10),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        labelText: 'Enter Name',
                        hintText: 'Enter Your Name'),
                    controller: nameController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //create button
                      ElevatedButton(
                        onPressed: insertIntoDatabase,
                        child: const Text('Create'),
                      ),
                      //read button
                      ElevatedButton(
                          onPressed: readDataFromDatabase,
                          child: const Text('Read')),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: contact.length,
                    itemBuilder: (_, int position) {
                      return Card(
                        child: ListTile(
                          leading: Text(contact.elementAt(position).name),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      updateFromDatabase(
                                          contact.elementAt(position).id,
                                          contact.elementAt(position).name);
                                    });
                                  },
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      deleteFromDatabase(
                                          contact.elementAt(position).id);
                                    });
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void insertIntoDatabase() async {
    displayText = nameController.text;
    await DatabaseHelper.instance
        .insert({DatabaseHelper.columnName: displayText});
    nameController.clear();
    readDataFromDatabase();
    contact = displayText as List<Contacts>;
  }

  void readDataFromDatabase() async {
    contact.clear();
    var dbquery = await DatabaseHelper.instance.queryDatabase();
    print(dbquery);
    for (int i = 0; i < dbquery.length; ++i) {
      Contacts item = Contacts(dbquery[i]["name"], dbquery[i]["id"]);
      contact.add(item);
    }
    setState(() {});
  }

  void updateFromDatabase(int idUpdate, String nameUpdate) async {
    displayText = nameController.text;
    Contacts items = Contacts(nameUpdate, idUpdate);
    await DatabaseHelper.instance.update({
      DatabaseHelper.columnId: items.id,
      DatabaseHelper.columnName: displayText
    });
    nameController.clear();

    readDataFromDatabase();
    contact = displayText as List<Contacts>;
  }

  void deleteFromDatabase(int id) async {
    await DatabaseHelper.instance.delete(id);
    readDataFromDatabase();
  }
}
