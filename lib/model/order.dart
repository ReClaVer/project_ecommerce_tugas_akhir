class Order {
  int idOrder;
  int idUser;
  String listShop;
  String delivery;
  String payment;
  String? note;
  double total;
  String image;
  String arrived;
  DateTime dateTime;
  String? image_path;

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
      required this.total,
      this.image_path});

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
      dateTime: DateTime.parse(json['date_time']),
      image_path: json['image_path']);

  Map<String, dynamic> toJson(String imageBase64) => {
        'delivery': delivery,
        'arrived': arrived,
        'id_order': idOrder.toString(),
        'id_user': idUser.toString(),
        'image': image,
        'image_path': imageBase64,
        'list_shop': listShop,
        'payment': payment,
        'total': total.toStringAsFixed(0),
        'note': note ?? '',

      };
}
