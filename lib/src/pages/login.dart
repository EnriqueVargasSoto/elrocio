import 'package:elrocio/src/pages/home.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 100.0, left: 25.0, right: 25.0),
      child: ListView(
        children: [
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Image(
                    image: AssetImage('assets/header_login.png')
                  ),
                )
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Center(
                  child: TextField(
                    decoration: new InputDecoration(
                      labelText: 'User'
                    ),
                    
                  ),
                )
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Center(
                  child: TextField(
                    obscureText: true,
                    decoration: new InputDecoration(
                      labelText: 'Password'
                    ),
                    
                  ),
                )
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: MaterialButton(
                      color: Color.fromRGBO(97, 0, 236, 1),
                      child: Text(
                        'INGRESAR', 
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      onPressed: (){
                        var ruta = MaterialPageRoute(builder: (context) => HomePage());
                        Navigator.push(context, ruta);
                      }
                    ),
                  ),
                )
              )
            ],
          )
        ],
      ),
    );
  }
}