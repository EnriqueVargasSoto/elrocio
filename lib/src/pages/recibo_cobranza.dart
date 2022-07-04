import 'package:elrocio/src/pages/detalle_pago.dart';
import 'package:flutter/material.dart';

class ReciboCobranza extends StatefulWidget {
  int PKCliente;
  String nombre;
  String doc_cliente;
  String letra;
  String numRecibo;
  String fecha;
  ReciboCobranza(this.PKCliente, this.nombre, this.doc_cliente, this.letra,
      this.numRecibo, this.fecha,
      {Key? key})
      : super(key: key);

  @override
  State<ReciboCobranza> createState() => _ReciboCobranzaState();
}

class _ReciboCobranzaState extends State<ReciboCobranza> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(97, 0, 236, 1),
          title: Text('Recibo de Cobranza'),
          centerTitle: true,
          actions: [
            /*GestureDetector(
              child: Icon(Icons.add),
            ),*/
            GestureDetector(
              child: Icon(Icons.save),
            ),
            SizedBox(
              width: 20.0,
            )
          ],
        ),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.only(top: 30.0, left: 25.0, right: 25.0),
      child: ListView(
        children: [
          _nombres(),
          _division(),
          _numeroRecibo(),
          _division(),
          _fecha(),
          _division(),
          _monto(),
          _division(),
          _btnAgregar()
          /*Container(
            height: 60.0,
            child: MaterialButton(
              color: Color.fromRGBO(97, 0, 236, 1),
              onPressed: () {
                var ruta =
                    MaterialPageRoute(builder: (context) => DetallePago());
                Navigator.push(context, ruta);
              },
              child: Icon(
                Icons.add_circle_outlined,
                size: 40.0,
                color: Colors.white,
              ),
            ),
          )*/
        ],
      ),
    );
  }

  Widget _division() {
    return SizedBox(
      height: 10.0,
    );
  }

  Widget _nombres() {
    return Text(
      'Cliente : ${widget.nombre}',
      style: TextStyle(fontSize: 25.0),
    );
  }

  Widget _numeroRecibo() {
    return Text(
      'Nro Recibo : ${widget.letra}-${widget.numRecibo}',
      style: TextStyle(fontSize: 25.0),
    );
  }

  Widget _fecha() {
    return Text(
      'Nro Recibo : ${widget.fecha}',
      style: TextStyle(fontSize: 25.0),
    );
  }

  Widget _monto() {
    return Text(
      'Nro Recibo : S/ 0.00',
      style: TextStyle(fontSize: 25.0),
    );
  }

  Widget _btnAgregar() {
    return Container(
      height: 60.0,
      child: MaterialButton(
        color: Color.fromRGBO(97, 0, 236, 1),
        onPressed: () {
          var ruta = MaterialPageRoute(builder: (context) => DetallePago());
          Navigator.push(context, ruta);
        },
        child: Icon(
          Icons.add_circle_outlined,
          size: 40.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
