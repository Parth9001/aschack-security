import 'package:flutter/material.dart';
// import 'package:frontend/login_page.dart';
import 'package:frontend/result_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

const bgcolor = Color(0xfffafafa);

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

Future<bool> verifyUser(String userID) async {
  final userData = await Hive.openBox('userData');

  for (var i = 0; i < userData.length; i++) {
    final entry = userData.getAt(i);
    if (entry != null && entry['name'] == userID) {
      return true;
    }
  }

  return false;
}

class _QRScannerState extends State<QRScanner> {
  bool isScanCompleted = false;
  bool isFlashON = false;
  bool isFrontCamera = false;
  MobileScannerController controller = MobileScannerController();
  void closeScreen() {
    isScanCompleted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      drawer: const Drawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFlashON = !isFlashON;
              });
              controller.toggleTorch();
            },
            icon: Icon(Icons.flash_on,
                color: isFlashON ? Colors.blue : Colors.grey),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isFrontCamera = !isFrontCamera;
              });
              controller.switchCamera();
            },
            icon: Icon(Icons.camera_front,
                color: isFrontCamera ? Colors.blue : Colors.grey),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: const Text(
          'QR Scanner',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Place the QR code in the area',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'Scanning will be started automatically',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            )),
            Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: controller,
                      allowDuplicates: true,
                      onDetect: (barcode, args) async {
                        if (!isScanCompleted) {
                          String code = barcode.rawValue ?? '---';
                          isScanCompleted = true;
                          print(code);
                          if (await verifyUser(code)) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResultScreen(
                                          closeScreen: closeScreen,
                                          code: 'Verfied',
                                        )));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => ResultScreen(
                                        closeScreen: closeScreen,
                                        code: 'Not Verified'))));
                          }
                        }
                      },
                    ),
                    // const QRScannerOverlay(overlayColour: bgcolor),
                  ],
                )),
            Expanded(
                child: Container(
              alignment: Alignment.center,
              child: Text(
                'Developed by DevCom',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

void dataEntry(Map<String, dynamic> data, String uID) async {
  final _qrList = Hive.box('qrList');
  data.forEach((key, value) async {
    var qq = {"eventName": value[1], "eventID": value[0], "uID": uID};
    await _qrList.add(qq);
    print(value[0]);
  });
}
// class Event {
//   final int token;
//   final String name;
//   final String location;
//   final DateTime date;
//   final TimeOfDay time;
//   final int noOfUsers;
//   final List<Map<String, dynamic>> users;

//   Event({
//     required this.token,
//     required this.name,
//     required this.location,
//     required this.date,
//     required this.time,
//     required this.noOfUsers,
//     required this.users,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'token': token,
//       'name': name,
//       'location': location,
//       'date': date.toIso8601String(), // Convert DateTime to a string
//       'time': time.toString(), // Convert TimeOfDay to a string
//       'no_of_users': noOfUsers,
//       'users': users, // Convert List of maps to a JSON string
//     };
//   }

//   // Add a factory constructor to create an Event object from a map
//   factory Event.fromMap(Map<String, dynamic> map) {
//     return Event(
//       token: map['token'],
//       name: map['name'],
//       location: map['location'],
//       date: DateTime.parse(map['date']), // Parse the date string
//       time: TimeOfDay.fromDateTime(
//           DateTime.parse(map['time'])), // Parse the time string
//       noOfUsers: map['no_of_users'],
//       users: List<Map<String, dynamic>>.from(
//           map['users']), // Decode the JSON string into a List of maps
//     );
//   }
// }

// class DatabaseHelper {
//   DatabaseHelper._();

//   static final DatabaseHelper instance = DatabaseHelper._();
//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;

//     _database = await initDatabase();
//     return _database!;
//   }

//   Future<Database> initDatabase() async {
//     final databasePath = await getDatabasesPath();
//     final path = join(databasePath, 'events.db');

//     return openDatabase(path, version: 1, onCreate: (db, version) {
//       return db.execute('''
//         CREATE TABLE events(
//           token INTEGER PRIMARY KEY,
//           name TEXT,
//           location TEXT,
//           date TEXT,
//           time TEXT,
//           no_of_users INTEGER,
//           users TEXT
//         )
//       ''');
//     });
//   }

//   Future<void> insertEvent(Event event) async {
//     final db = await instance.database;
//     await db.insert('events', event.toMap(),
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   Future<bool> userExists(int userId) async {
//     final db = await instance.database;
//     final List<Map<String, dynamic>> results = await db.query('events',
//         where: 'users LIKE ?', whereArgs: ['%$userId%']);

//     return results.isNotEmpty;
//   }
// }

// Future<Database> openDatabase(
//     {required String path,
//     required int version,
//     required Function(dynamic db, dynamic version) onCreate}) async {
//   final databasePath = await getDatabasesPath();
//   final dbpath = join(databasePath, 'events.db');

//   return openDatabase(
//     path: dbpath,
//     version: version,
//     onCreate: onCreate,
//   );
// }

// Future<void> insertEvent(Event event) async {
//   final Database database = await openDatabase(
//     path: 'events.db',
//     version: 1,
//     onCreate: (db, version) {
//       return db.execute('''
//       CREATE TABLE events(
//         token INTEGER PRIMARY KEY,
//         name TEXT,
//         location TEXT,
//         date TEXT,
//         time TEXT,
//         no_of_users INTEGER,
//         users TEXT
//       )
//     ''');
//     },
//   );

//   await database.insert(
//     'events',
//     event.toMap(),
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
// }

// Future<List<Event>> fetchEventData() async {
//   String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   final response = await http.get(Uri.parse(
//       'https://93c9-103-21-126-76.ngrok-free.app/scanner_app/fetch_data/$formattedDate/'));
//   if (response.statusCode == 200) {
//     final List<dynamic> data = jsonDecode(response.body);
//     final List<Event> events =
//         data.map((eventData) => Event.fromMap(eventData)).toList();
//     for (final event in events) {
//       await insertEvent(event);
//     }
//     return events;
//   } else {
//     throw Exception('Failed to load event data');
//   }
// }

// class DatabaseHelper {
//   DatabaseHelper._();

//   static final DatabaseHelper instance = DatabaseHelper._();
//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;

//     _database = await initDatabase();
//     return _database!;
//   }

//   Future<Database> initDatabase() async {
//     final databasePath = await getDatabasesPath();
//     final path = join(databasePath, 'your_database.db');

//     return openDatabase(path, version: 1, onCreate: (db, version) {
//       // Define your database tables and schema here
//     });
//   }
// }

// Future<bool> doesUserExist(int userId) async {
//   final db = await DatabaseHelper.instance.database;
//   final result = await db.query(
//     'usersTable',
//     where: 'userId = ?',
//     whereArgs: [userId],
//   );

//   return result.isNotEmpty;

