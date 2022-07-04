import 'package:flutter/material.dart';

class SaldoCliente extends StatefulWidget {
  SaldoCliente({Key? key}) : super(key: key);

  @override
  State<SaldoCliente> createState() => _SaldoClienteState();
}

class _SaldoClienteState extends State<SaldoCliente> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(97, 0, 236, 1),
            title: Text('Documentos por Cobrar'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 30.0, left: 25.0, right: 25.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Saldo Total : S/ 10,001.79',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                  child: Container(
                child: ListView(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Tipo Doc : A'),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text('Nro : 512150')
                            ],
                          ),
                          Row(
                            children: [
                              Text('Fecha Doc : 22/04/2022'),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text('Vencimiento : 22/04/2022')
                            ],
                          ),
                          Row(
                            children: [
                              Text('Moneda : PEN'),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text('Vendedor : Miguel Cordova')
                            ],
                          ),
                          Row(
                            children: [
                              Text('Monto Total : -4,012.57'),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text('Monto Pendiente : -4,012.57')
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ))
            ],
          )),
    );
  }
}
