class Apparel {
  int idApparel;
  String name;
  double rating;
  double price;
  List<String> sizes;

  String? description;
  String image;

  Apparel({
    required this.description,
    required this.idApparel,
    required this.image,
    required this.name,
    required this.price,
    required this.rating,
    required this.sizes,
  });

  factory Apparel.fromJson(Map<String, dynamic> json) => Apparel(
      idApparel: int.parse(json['id_apparel']),
      image: json['image'],
      name: json['name'],
      price: double.parse(json['price']),
      rating: double.parse(json['rating']),
      sizes: json['sizes'].toString().split(', '),
      description: json['description']);

  Map<String, dynamic> toJson() => {
        'id_apparel': idApparel,
        'name': name,
        'rating': rating,
        'price': price.toStringAsFixed(0),
        'sizes': sizes,
        'description': description,
        'image': image
      };
}
