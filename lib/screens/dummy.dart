import 'package:firebase_products/screens/sqfExample.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SampleData extends StatefulWidget {
  const SampleData({super.key});

  @override
  State<SampleData> createState() => _SampleDataState();
}

class _SampleDataState extends State<SampleData> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<DataBaseModel> userDataList = [];
  List<DataBaseModel> dataModels = [];
  List<DataBaseModel> newData = [];

  bool isEditing = false;
  int editingRowIndex = -1;

  TextEditingController editingNameController = TextEditingController();
  TextEditingController editingAgeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    // databaseHelper.database;
    //await databaseHelper.initDatabase();
    // await databaseHelper.insertUserData(DataBaseModel(1, 'Ruby', 20));
     await fetchData();
  }

  Future<void> fetchData() async {
    userDataList = await databaseHelper.getUserData();
    print('userDataList ${userDataList[0].id}');
    assignDataToModel();
  }

  void assignDataToModel() {
    dataModels.clear();
    for (var data in userDataList) {
      setState(() {
        dataModels.add(DataBaseModel(
          data.id,
          data.name,
          data.age,
        ));
      });

    }
    print(dataModels);
  }

  void saveChanges() async {
    if (isEditing && editingRowIndex >= 0 && editingRowIndex < dataModels.length) {
      if (editingNameController.text != dataModels[editingRowIndex].name ||
          editingAgeController.text != dataModels[editingRowIndex].age.toString()) {
        await databaseHelper.updateUserData(DataBaseModel(
          dataModels[editingRowIndex].id,
          editingNameController.text,
          int.parse(editingAgeController.text),
        ));

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

  void handleCellTap(int rowIndex) {
    setState(() {
      isEditing = true;
      editingRowIndex = rowIndex;
      editingNameController.text = dataModels[rowIndex].name;
      editingAgeController.text = dataModels[rowIndex].age.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sqflite Example'),
        actions: [
          IconButton(onPressed: () {
            databaseHelper.insertUserData(DataBaseModel(4, 'Mani', 28));
            fetchData();
          }, icon: const Icon(Icons.add))
        ],
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
}

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    print('database cond');
    if (_database != null) {
      print('database cond not null');
      // _database = null; // Set _database to null after dropping the table
      // print('data null value 1 $_database');
      //await database;
      //_database = null;
      return _database!;
    } else {
      print('database cond null');
      _database = await initDatabase();
      insertUserData(DataBaseModel(1, 'Ruby', 20));

      return _database!;
    }
  }

  // DatabaseHelper() {
  //   initDatabase();
  // }

  Future<Database> initDatabase() async {
    print('calling initDatabase');
    var databasesPath = await getDatabasesPath();
    String pathToDatabase = join(databasesPath, 'example1.db');

    return openDatabase(
      pathToDatabase,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE user_data (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)');
      },
    );
  }

  Future<void> insertUserData(DataBaseModel userData) async {
    Database db = await database;
    await db.insert('user_data', userData.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    getUserData();
  }

  Future<List<DataBaseModel>> getUserData() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('user_data');
    print('maps value $maps');
    return List.generate(maps.length, (i) {
      return DataBaseModel(
        maps[i]['id'],
        maps[i]['name'],
        maps[i]['age'],
      );
    });
  }

  Future<void> updateUserData(DataBaseModel userData) async {
    Database db = await database;

    await db.update(
      'user_data',
      userData.toMap(),
      where: 'id = ?',
      whereArgs: [userData.id],
    );
  }

  Future<void> dropTable() async {
    Database db = await database;
    await db.execute('DROP TABLE IF EXISTS user_data');
    print('data null value 0');
    _database = null; // Set _database to null after dropping the table
    print('data null value 1 $_database');
    await database;
    print('data null value 1 $_database');
  }
}