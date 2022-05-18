import 'package:flutter/material.dart';

class TransaccionesPage extends StatefulWidget {
  TransaccionesPage({Key? key}) : super(key: key);

  @override
  State<TransaccionesPage> createState() => _TransaccionesPageState();
}

class _TransaccionesPageState extends State<TransaccionesPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Transacciones'),
          centerTitle: true,
        ),
        body: Container(
          child: ListView(
            children: [
              Expanded(
                child: MaterialButton(
                  color: Color.fromRGBO(97, 0, 236, 1),
                  child: Text('Pedidos', style: TextStyle(color: Colors.white),),
                  onPressed: (){}
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}