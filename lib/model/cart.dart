class Cart {
  int idCart;
  int idUser;
  int idApparel;
  String name;
  double rating;
  List<String>? tags;
  double price;
  List<String>? sizes;
  List<String>? colors;
  String? description;
  String image;
  int quantity;

  Cart(
      {required this.colors,
      this.description,
      required this.idCart,
      required this.idApparel,
      required this.idUser,
      required this.image,
      required this.name,
      required this.price,
      required this.quantity,
      required this.rating,
      required this.sizes,
      this.tags});

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
      colors: json['colors'].toString().split(', '),
      idCart: int.parse(json['id_cart']),
      idApparel: int.parse(json['id_shoes']),
      idUser: int.parse(json['id_user']),
      image: json['image'],
      name: json['name'],
      price: double.parse(json['price']),
      quantity: int.parse(json['quantity']),
      rating: double.parse(json['rating']),
      tags: json['tags'].toString().split(', '),
      sizes: json['sizes'].toString().split(', '),
      description: json['description']);

  Map<String, dynamic> toJson() => {
        'id_cart': idCart,
        'id_shoes': idApparel,
        'id_user': idUser,
        'quantity': quantity
      };
}
