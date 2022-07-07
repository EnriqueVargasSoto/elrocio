import 'package:elrocio/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaldoCliente extends StatefulWidget {
  int PKCliente;
  String doc_cliente;
  String nombre;
  String saldopendiente;
  SaldoCliente(
      this.PKCliente, this.doc_cliente, this.nombre, this.saldopendiente,
      {Key? key})
      : super(key: key);

  @override
  State<SaldoCliente> createState() => _SaldoClienteState();
}

class _SaldoClienteState extends State<SaldoCliente> {
  Future<List<dynamic>> _getVoletas(int codigo) async {
    List<dynamic> arrVoletas = await SQLHelper.getVoletas(codigo);
    print(arrVoletas);
    return arrVoletas;
  }

  @override
  void initState() {
    _getVoletas(widget.PKCliente);
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(97, 0, 236, 1),
            title: Text('Documentos por Cobrar'),
            centerTitle: true,
          ),
          body: _body()),
    );
  }

  Widget _body() {
    return Column(
      children: [
        _containerTitle(),
        SizedBox(
          height: 10,
        ),
        _listaVoletas()
      ],
    );
  }

  Widget _containerTitle() {
    return Container(
      padding: EdgeInsets.only(top: 30.0, left: 25.0, right: 25.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Saldo Total : S/ ${widget.saldopendiente}',
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _listaVoletas() {
    return FutureBuilder(
      future: _getVoletas(widget.PKCliente),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        return Expanded(
            child: Container(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: _listarVoletas(snapshot.data ?? [], context),
          ),
        ));
      },
    );
  }

  List<Widget> _listarVoletas(List<dynamic> data, BuildContext context) {
    final List<Widget> voletas = [];

    data.forEach((element) {
      final widgetTemp = Container(
        width: double.infinity,
        child: Column(
          children: [
            _primerRow(element),
            SizedBox(
              height: 5.0,
            ),
            _segundoRow(element),
            SizedBox(
              height: 5.0,
            ),
            _tercerRow(element),
            SizedBox(
              height: 5.0,
            ),
            _cuartoRow(element)
          ],
        ),
      );

      voletas
        ..add(widgetTemp)
        ..add(Divider());
    });

    return voletas;
  }

  Widget _primerRow(voleta) {
    String tipo = '';
    if (voleta['tipoDocumento'] == 'PAGO') {
      tipo = 'A';
    } else {
      tipo = 'F';
    }
    return Row(
      children: [
        Flexible(
          child: Text('Tipo Doc: ${tipo}',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0)),
        ),
        SizedBox(
          width: 20.0,
        ),
        Flexible(
            child: Text(
          'Nro: ${voleta['numDocumento']}',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15.0),
        )),
      ],
    );
  }

  Widget _segundoRow(voleta) {
    return Row(
      children: [
        Flexible(
          child: Text(
            'Fecha Doc: ${voleta['fechaDocumento']}',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 15.0),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Flexible(
          child: Text(
            'Vencimiento: ${voleta['fechaVencimiento']}',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 15.0),
          ),
        ),
        //Text('Vencimiento : 22/04/2022')
      ],
    );
  }

  Widget _tercerRow(voleta) {
    return Row(
      children: [
        Flexible(
          child: Text(
            'Moneda : ${voleta['monedaVenta']}',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 15.0),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Flexible(
            child: Text(
          'Vendedor : ${voleta['nomVendedor']}',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 15.0),
        ))
      ],
    );
  }

  Widget _cuartoRow(voleta) {
    return Row(
      children: [
        Flexible(
          child: Text(
            'Monto Total : ${voleta['montoMonedaFun']}',
            style: TextStyle(
                color: Color.fromRGBO(97, 0, 236, 1),
                fontWeight: FontWeight.w400,
                fontSize: 15.0),
          ),
        ),
        SizedBox(
          width: 17.0,
        ),
        Flexible(
            child: Text(
          'Monto Pendiente : ${voleta['saldoMonedaFun']}',
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.w400, fontSize: 15.0),
        ))
      ],
    );
  }
}
