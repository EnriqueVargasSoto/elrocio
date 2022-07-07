import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportePolloVivo extends StatefulWidget {
  ReportePolloVivo({Key? key}) : super(key: key);

  @override
  State<ReportePolloVivo> createState() => _ReportePolloVivoState();
}

class _ReportePolloVivoState extends State<ReportePolloVivo> {
  DateTime _selectedDate = DateTime.now();
  String _fecha = '';

  void setearDatos() {
    _fecha = DateFormat('dd/MM/yyyy').format(_selectedDate);
  }

  //Future<List<dynamic>> getPedidosPolloVivo() {}

  @override
  void initState() {
    setearDatos();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(97, 0, 236, 1),
          title: Text('Pedidos del Día: ${_fecha}'),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(top: 30.0, left: 25.0, right: 25.0),
          child: ListView(
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1 - ANA RODRIGUEZ CAMPOS',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Total: 509.60 - Tipo : TRU-VT-GRV-POLLO VIVO',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Dir : asdaskdjhakdhakdhakdhkasdhakjhdkajhdkajdhkajsdhkajdhkasdhajkdhajsdhjkahdkjasdkjasdhkjasdhasjkdkashdasjkdh',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Sub Cliente: NAYSER',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
                    )
                  ],
                ),
              ),
              Divider(),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2 - ANA RODRIGUEZ CAMPOS',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Total: 509.60 - Tipo : TRU-VT-GRV-POLLO VIVO',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Dir : asdaskdjhakdhakdhakdhkasdhakjhdkajhdkajdhkajsdhkajdhkasdhajkdhajsdhjkahdkjasdkjasdhkjasdhasjkdkashdasjkdh',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Sub Cliente: NAYSER',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
                    )
                  ],
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
