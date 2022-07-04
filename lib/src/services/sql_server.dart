import 'package:flutter/material.dart';
import 'package:sql_conn/sql_conn.dart';

class SqlServer extends StatefulWidget {
  SqlServer({Key? key}) : super(key: key);

  @override
  State<SqlServer> createState() => _SqlServerState();
}

class _SqlServerState extends State<SqlServer> {
  String user = 'u_wost';
  String pass = '\$w0st#sql+';
  Future<void> connect(BuildContext ctx) async {
    debugPrint("Connecting...");
    print('**********');
    print(user);
    print(pass);
    print('**********');
    try {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("LOADING"),
            content: CircularProgressIndicator(),
          );
        },
      );
      await SqlConn.connect(
          ip: "10.45.0.218",
          port: "1443",
          databaseName: "BD_Comercial",
          username: user,
          password: pass);
      debugPrint("Connected!");
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
