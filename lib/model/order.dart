class Order {
  int idOrder;
  int idUser;
  String listShop;
  String delivery;
  double payment;
  String? note;
  double total;
  String image;
  String arrived;
  DateTime dateTime;

  Order(
      {required this.arrived,
      required this.dateTime,
      required this.delivery,
      required this.idOrder,
      required this.idUser,
      required this.image,
      required this.listShop,
      this.note,
      required this.payment,
      required this.total});

  factory Order.fromJson(Map<String, dynamic> json) => Order(
      arrived: json['arrived'],
      delivery: json['delivery'],
      idOrder: int.parse(json['id_order']),
      idUser: int.parse(json['id_user']),
      image: json['image'],
      listShop: json['list_shop'],
      total: double.parse(json['total']),
      payment: json['payment'],
      note: json['note'],
      dateTime: DateTime.parse(json['date_time']));

  Map<String, dynamic> toJson(String imageBase64) => {
        'delivery': this.delivery,
        'id_order': this.idOrder,
        'id_user': this.idUser,
        'image': this.image,
        'image_file': imageBase64,
        'list_shop': this.listShop,
        'payment': this.payment,
        'total': this.total,
        'note': this.note
      };
}
