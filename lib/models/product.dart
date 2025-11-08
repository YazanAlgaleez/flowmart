class Product {
  final String id;
  final String name;
  final double price;
  final double? discount;
  final String imageUrl;
  final String? videoUrl;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.discount,
    required this.imageUrl,
    this.videoUrl,
    required this.description,
  });

  double get discountedPrice =>
      discount != null ? price * (1 - discount!) : price;

  bool get hasDiscount => discount != null && discount! > 0;
}
