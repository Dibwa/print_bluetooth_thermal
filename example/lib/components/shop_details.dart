class Shop{

    final String shopName;

  final String shopCategory;

  final String shopIcon;

  const Shop({
    required this.shopName,
    required this.shopCategory,
    required this.shopIcon,
  });

  static Shop fromJson(json) => Shop(
      shopName: json['shopName'],
      shopCategory: json['shopCategory'],
      shopIcon: json['shopIcon']);



}