class Product {
  String id = "";
  String name = "";
  String category = "";
  double price = 0;
  List<String> imagesURL = <String>[];

  Product();
  Product.fromData(this.id, this.name, this.category, this.price, this.imagesURL);

  Product.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.category = json['category'];
    this.price = json['price'].toDouble();
    this.imagesURL = List<String>.from(json['imagesURL']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category'] = this.category;
    data['price'] = this.price;
    data['imagesURL'] = this.imagesURL;
    return data;
  }
}
