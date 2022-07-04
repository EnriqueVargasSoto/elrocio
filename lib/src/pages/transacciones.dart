import 'package:elrocio/src/pages/home.dart';
import 'package:elrocio/src/pages/pedidos.dart';
import 'package:flutter/material.dart';

class TransaccionesPage extends StatefulWidget {
  TransaccionesPage({Key? key}) : super(key: key);

  @override
  State<TransaccionesPage> createState() => _TransaccionesPageState();
}

class _TransaccionesPageState extends State<TransaccionesPage> {
  @override
  void initState() {
    //conexion();
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(97, 0, 236, 1),
          title: Text('Transacciones'),
          centerTitle: true,
          leading: BackButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 50.0, left: 25.0, right: 25.0),
          child: ListView(
            children: [_btnPedidos(), _btnCobranza()],
          ),
        ),
      ),
    );
  }

  Widget _btnPedidos() {
    return Container(
      height: 50.0,
      child: MaterialButton(
          color: Color.fromRGBO(97, 0, 236, 1),
          child: Text(
            'PEDIDOS',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            var ruta = MaterialPageRoute(builder: (context) => PedidoPage());
            Navigator.push(context, ruta);
          }),
    );
  }

  Widget _btnCobranza() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      height: 50.0,
      child: MaterialButton(
          color: Color.fromRGBO(97, 0, 236, 1),
          child: Text(
            'COBRANZA',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {}),
    );
  }
}
