class Wishlist {
  int idWishlist;
  int idUser;
  int idApparel;
  String name;
  double rating;
  List<String>? tags;
  double price;
  List<String> sizes;
  List<String> colors;
  String? description;
  String image;

  Wishlist(
      {required this.colors,
      this.description,
      required this.idApparel,
      required this.idUser,
      required this.idWishlist,
      required this.image,
      required this.name,
      required this.price,
      required this.rating,
      required this.sizes,
      this.tags});

  factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
      idWishlist: int.parse(json['id_wishlist']),
      idApparel: int.parse(json['id_apparel']),
      idUser: int.parse(json['id_user']),
      name: json['name'],
      rating: double.parse(json['rating']),
      tags: json['tags'].toString().split(', '),
      price: double.parse(json['price']),
      sizes: json['sizes'].toString().split(', '),
      colors: json['colors'].toString().split(', '),
      description: json['description'],
      image: json['image']);

  Map<String, dynamic> toJson() =>
      {'id_wishlist': idWishlist, 'id_user': idUser, 'id_apparel': idApparel};
}
