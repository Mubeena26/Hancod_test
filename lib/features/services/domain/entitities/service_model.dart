class ServiceModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String duration;
  final double rating;
  final int orderCount;
  final String category;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.duration,
    required this.rating,
    required this.orderCount,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'duration': duration,
      'rating': rating,
      'order_count': orderCount,
      'category': category,
    };
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      duration: json['duration'] as String,
      rating: (json['rating'] as num).toDouble(),
      orderCount: json['order_count'] as int,
      category: json['category'] as String,
    );
  }
}
