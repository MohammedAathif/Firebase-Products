///
// import 'package:flutter/material.dart';
// import 'package:path/path.dart' as paths;
// import 'package:sqflite/sqflite.dart';
//
// class SqliteExample extends StatefulWidget {
//   const SqliteExample({super.key});
//
//   @override
//   State<SqliteExample> createState() => _SqliteExampleState();
// }
//
// class _SqliteExampleState extends State<SqliteExample> {
//   late Database _database;
//
//   TextEditingController nameController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//
//   String errorMessage = '';
//
//   List<Map<String, dynamic>> retrievedData = [];
//   List<DataBaseModel> dataModels = [];
//   int selectedItemId = -1;
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initDatabase();
//   }
//
//   Future<void> _initDatabase() async {
//
//     var databasePath = await getDatabasesPath();
//     String path = paths.join(databasePath, 'example.db');
//
//     await deleteDatabase(path);
//
//     _database = await openDatabase(path, version: 1,
//        onCreate: (Database db, int version) async {
//           await db.execute(
//             'CREATE TABLE my_table (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)'
//           );
//        }
//     );
//   }
//
//   Future<void> _insertData(name,age) async {
//
//     setState(() => isLoading = true);
//
//     await _database.transaction((txn) async {
//       await txn.rawInsert(
//             'INSERT INTO my_table(name, age) VALUES("$name", $age)'
//       );
//     });
//
//     fetchData();
//   }
//
//   Future<void> updateData(id,name,age) async {
//     setState(() => isLoading = true);
//
//     await _database.transaction((txn) async {
//       await txn.update(
//           'my_table',{"name":"$name", "age": age},where: 'id = $id');
//     });
//
//     fetchData();
//   }
//
//   Future<List<Map<String, dynamic>>> _retrieveData() async {
//
//     return await _database.rawQuery('SELECT * FROM my_table');
//
//     // delete command
//     //return await _database.rawQuery('DROP TABLE IF EXISTS my_table');
//   }
//
//   void assignDataToModel() {
//     dataModels.clear();
//     for (var data in retrievedData) {
//       dataModels.add(DataBaseModel(
//         data['id'],
//         data['name'],
//         data['age'],
//       ));
//     }
//   }
//
//   void fetchData() async {
//     retrievedData =  await _retrieveData();
//     assignDataToModel();
//
//     Future.delayed(const Duration(milliseconds: 400)).then((value) {
//       setState(() => isLoading = false);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sqflite Example'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 40),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: nameController,
//                 onChanged: (val) {
//                   setState(() {
//                     errorMessage = '';
//                   });
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: ageController,
//                 onChanged: (val) {
//                   setState(() {
//                     errorMessage = '';
//                   });
//                 },
//               ),
//             ),
//             if(errorMessage != '')
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                     alignment: Alignment.bottomLeft,
//                     child: Text(errorMessage)),
//               ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () async {
//                     if(nameController.text == '' || ageController.text == '') {
//                       setState(() {
//                         errorMessage = 'enter name and age';
//                       });
//                     } else {
//                       await _insertData(nameController.text,ageController.text);
//                       nameController.clear();
//                       ageController.clear();
//                       FocusScope.of(context).unfocus();
//                       print('Data inserted');
//                     }
//                   },
//                   child: const Text('Insert Data'),
//                 ),
//                 // SizedBox(width: 10),
//                 // ElevatedButton(
//                 //   onPressed: () async {
//                 //     retrievedData =  await _retrieveData();
//                 //     assignDataToModel();
//                 //     print('Retrieved Data: $retrievedData');
//                 //
//                 //     setState(() { });
//                 //   },
//                 //   child: const Text('Retrieve Data'),
//                 // ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     // retrievedData =  await _retrieveData();
//                     // assignDataToModel();
//                     // print('Retrieved Data: $retrievedData');
//                     if(selectedItemId != -1) {
//                       setState(() {
//                         errorMessage = '';
//                       });
//                       updateData(selectedItemId,nameController.text,ageController.text);
//                       nameController.clear();
//                       ageController.clear();
//                       FocusScope.of(context).unfocus();
//                     } else {
//                       setState(() {
//                         errorMessage = 'There is no such file';
//                       });
//                     }
//                   },
//                   child: const Text('Update Data'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             SizedBox(
//               height: 420,
//               child: isLoading ? const Center(child: CircularProgressIndicator()) : ListView.builder(itemBuilder: (context,index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: InkWell(
//                     onTap: () {
//                       print('ontapped');
//                       setState(() {
//                         selectedItemId = dataModels[index].id;
//                         nameController.text = dataModels[index].name;
//                         ageController.text = dataModels[index].age.toString();
//                       });
//                     },
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if(index == 0)
//                           const Padding(
//                             padding: EdgeInsets.only(bottom: 20.0),
//                             child: Text('Stored DB Datas are: '),
//                           ),
//                         Text('id: ${dataModels[index].id}'),
//                         const SizedBox(height: 5),
//                         Text('name: ${dataModels[index].name}'),
//                         const SizedBox(height: 5),
//                         Text('age: ${dataModels[index].age}'),
//                       ],
//                     ),
//                   ),
//                 );
//               },itemCount: retrievedData.length,),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
///
///
// class SqliteExample extends StatefulWidget {
//   const SqliteExample({super.key});
//
//   @override
//   State<SqliteExample> createState() => _SqliteExampleState();
// }
//
// class _SqliteExampleState extends State<SqliteExample> {
//   late Database _database;
//
//   TextEditingController nameController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//
//   String errorMessage = '';
//
//   List<Map<String, dynamic>> retrievedData = [];
//   List<DataBaseModel> dataModels = [];
//   int selectedItemId = -1;
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initDatabase();
//   }
//
//   Future<void> _initDatabase() async {
//
//     var databasePath = await getDatabasesPath();
//     String path = paths.join(databasePath, 'example.db');
//
//     await deleteDatabase(path);
//
//     _database = await openDatabase(path, version: 1,
//        onCreate: (Database db, int version) async {
//           await db.execute(
//             'CREATE TABLE my_table (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)'
//           );
//        }
//     );
//   }
//
//   Future<void> _insertData(name,age) async {
//
//     setState(() => isLoading = true);
//
//     await _database.transaction((txn) async {
//       await txn.rawInsert(
//             'INSERT INTO my_table(name, age) VALUES("$name", $age)'
//       );
//     });
//
//     fetchData();
//   }
//
//   Future<void> updateData(id,name,age) async {
//     setState(() => isLoading = true);
//
//     await _database.transaction((txn) async {
//       await txn.update(
//           'my_table',{"name":"$name", "age": age},where: 'id = $id');
//     });
//
//     fetchData();
//   }
//
//   Future<List<Map<String, dynamic>>> _retrieveData() async {
//
//     return await _database.rawQuery('SELECT * FROM my_table');
//
//     // delete command
//     //return await _database.rawQuery('DROP TABLE IF EXISTS my_table');
//   }
//
//   void assignDataToModel() {
//     dataModels.clear();
//     for (var data in retrievedData) {
//       dataModels.add(DataBaseModel(
//         data['id'],
//         data['name'],
//         data['age'],
//       ));
//     }
//   }
//
//   void fetchData() async {
//     retrievedData =  await _retrieveData();
//     assignDataToModel();
//
//     Future.delayed(const Duration(milliseconds: 400)).then((value) {
//       setState(() => isLoading = false);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sqflite Example'),
//       ),
//       body: DataTable(
//         columns: [
//           DataColumn(label: Text('ID')),
//           DataColumn(label: Text('Name')),
//           DataColumn(label: Text('Age')),
//         ],
//         rows: dataModels.asMap().entries.map((entry) {
//           int rowIndex = entry.key;
//           DataBaseModel data = entry.value;
//           return DataRow(cells: [
//             DataCell(Text(data.id.toString())),
//             DataCell(
//               isEditing && editingRowIndex == rowIndex
//                   ? TextFormField(
//                 controller: editingNameController,
//               )
//                   : GestureDetector(
//                 onTap: () => handleCellTap(rowIndex, data.name, data.age),
//                 child: Text(data.name),
//               ),
//             ),
//             DataCell(
//               isEditing && editingRowIndex == rowIndex
//                   ? TextFormField(
//                 controller: editingAgeController,
//               )
//                   : GestureDetector(
//                 onTap: () => handleCellTap(rowIndex, data.name, data.age),
//                 child: Text(data.age.toString()),
//               ),
//             ),
//           ]);
//         }).toList(),
//       ),
//     );
//   }
//
//   bool isEditing = false;
//   int editingRowIndex = -1;
//   TextEditingController editingNameController = TextEditingController();
//   TextEditingController editingAgeController = TextEditingController();
//
//   void handleCellTap(int rowIndex, String name, int age) {
//     setState(() {
//       isEditing = true;
//       editingRowIndex = rowIndex;
//       editingNameController.text = name;
//       editingAgeController.text = age.toString();
//     });
//   }
// }
//
// class DataBaseModel {
//   DataBaseModel(this.id,this.name,this.age);
//   int id; String name; int age;
// }
///
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as paths;

class SqliteExample extends StatefulWidget {
  const SqliteExample({Key? key}) : super(key: key);

  @override
  State<SqliteExample> createState() => _SqliteExampleState();
}

class _SqliteExampleState extends State<SqliteExample> {
  late Database _database;
  TextEditingController editingNameController = TextEditingController();
  TextEditingController editingAgeController = TextEditingController();


  List<Map<String, dynamic>> retrievedData = [];
  List<DataBaseModel> userDataList = [];
  List<DataBaseModel> dataModels = [];
  List<DataBaseModel> newData = [];

  bool isEditing = false;
  int editingRowIndex = -1;


  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = paths.join(databasePath, 'example.db');

    await deleteDatabase(path);

    _database = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE my_table (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)');
    });
    _insertData('Rubesh', 20);
    _insertData('Mani', 40);
    _insertData('Pradeep', 24);
    _insertData('Mohan', 22);
    _insertData('Rocky', 21);
    _insertData('Azar', 30);
    fetchData();
  }

  Future<void> _insertData(name, age) async {

    await _database.transaction((txn) async {
      await txn.rawInsert('INSERT INTO my_table(name, age) VALUES("$name", $age)');
    });

    fetchData();
  }

  Future<void> updateData(id, name, age) async {

    await _database.transaction((txn) async {
      await txn.update('my_table', {"name": "$name", "age": age}, where: 'id = $id');
    });

    fetchData();
  }

  Future<List<Map<String, dynamic>>> _retrieveData() async {
    return await _database.rawQuery('SELECT * FROM my_table');
  }

  void fetchData() async {
    retrievedData = await _retrieveData();
    assignDataToModel();
  }

  void assignDataToModel() {
    dataModels.clear();
    for (var data in retrievedData) {
      setState(() {
        dataModels.add(DataBaseModel(
          data['id'],
          data['name'],
          data['age'],
        ));
      });

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sqflite Example'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Age')),
              ],
              rows: dataModels.asMap().entries.map((entry) {
                int rowIndex = entry.key;
                DataBaseModel data = entry.value;
                return DataRow(cells: [
                  DataCell(Text(data.id.toString())),
                  DataCell(
                    isEditing && editingRowIndex == rowIndex
                        ? TextFormField(
                            controller: editingNameController,
                            onChanged: (value) {
                                if (editingRowIndex < newData.length) {
                                  newData[editingRowIndex] = DataBaseModel(
                                    dataModels[editingRowIndex].id,
                                    value,
                                    newData[editingRowIndex].age,  // Keep the existing age
                                  );
                                }
                            },
                          )
                        : GestureDetector(
                            onTap: () => handleCellTap(rowIndex),
                            child: Text(data.name),
                          ),
                  ),
                  DataCell(
                    isEditing && editingRowIndex == rowIndex
                        ? TextFormField(
                            controller: editingAgeController,
                            onChanged: (value) {

                              if (editingRowIndex < newData.length) {
                                newData[editingRowIndex] = DataBaseModel(
                                  dataModels[editingRowIndex].id,
                                  editingNameController.text,
                                  int.parse(value), // Updated age
                                );
                              }
                            },
                          )
                        : GestureDetector(
                            onTap: () => handleCellTap(rowIndex),
                            child: Text(data.age.toString()),
                          ),
                  ),
                ]);
              }).toList(),
            ),
            const SizedBox(height: 10),
            if (isEditing)
              ElevatedButton(
                onPressed: saveChanges,
                child: const Text('Save Changes'),
              ),
          ],
        ),
      ),
    );
  }

  void handleCellTap(int rowIndex) {
    setState(() {
      isEditing = true;
      editingRowIndex = rowIndex;
      editingNameController.text = dataModels[rowIndex].name;
      editingAgeController.text = dataModels[rowIndex].age.toString();
    });
  }

  void saveChanges() async {
    if (isEditing && editingRowIndex >= 0 && editingRowIndex < dataModels.length) {
      if (editingNameController.text != dataModels[editingRowIndex].name ||
          editingAgeController.text != dataModels[editingRowIndex].age.toString()) {
        // await updateData(
        //   dataModels[editingRowIndex].id,
        //   editingNameController.text,
        //   int.parse(editingAgeController.text),
        // );

        //Update the dataModels list directly
        dataModels[editingRowIndex] = DataBaseModel(
          dataModels[editingRowIndex].id,
          editingNameController.text,
          int.parse(editingAgeController.text),
        );

        setState(() {
          isEditing = false;
          editingRowIndex = -1;
        });
      } else {
        setState(() {
          isEditing = false;
          editingRowIndex = -1;
        });
      }
    }
  }
}

class DataBaseModel {
  DataBaseModel(this.id, this.name, this.age);
  int id;
  String name;
  int age;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }
}