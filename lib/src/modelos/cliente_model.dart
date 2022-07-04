class Cliente {
  final int? customer_id;
  final int? customer_number;
  final String? customer_name;

  Cliente({this.customer_id, this.customer_number, this.customer_name});

  factory Cliente.fromJson(Map<String, dynamic> parsedJson) {
    print('entre al factory');
    print(parsedJson);
    return Cliente(
        customer_id: parsedJson['customer_id'],
        customer_number: parsedJson['customer_number'],
        customer_name: parsedJson['customer_name']);
  }
}
