class DataCart {
  DataCart({
    this.success,
    this.data,
  });
  late final bool? success;
  late final List<Data>? data;
  
  DataCart.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data!.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    this.idCart,
    this.idUser,
    this.idApparel,
    this.quantity,
    this.name,
    this.rating,
    this.tags,
    this.price,
    this.size,
    this.colors,
    this.description,
    this.image,
  });
  late final String? idCart;
  late final String? idUser;
  late final String? idApparel;
  late final String? quantity;
  late final String? name;
  late final String? rating;
  late final String? tags;
  late final String? price;
  late final String? size;
  late final String? colors;
  late final String? description;
  late final String? image;
  
  Data.fromJson(Map<String, dynamic> json){
    idCart = json['id_cart'];
    idUser = json['id_user'];
    idApparel = json['id_apparel'];
    quantity = json['quantity'];
    name = json['name'];
    rating = json['rating'];
    tags = json['tags'];
    price = json['price'];
    size = json['size'];
    colors = json['colors'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id_cart'] = idCart;
    _data['id_user'] = idUser;
    _data['id_apparel'] = idApparel;
    _data['quantity'] = quantity;
    _data['name'] = name;
    _data['rating'] = rating;
    _data['tags'] = tags;
    _data['price'] = price;
    _data['size'] = size;
    _data['colors'] = colors;
    _data['description'] = description;
    _data['image'] = image;
    return _data;
  }
}