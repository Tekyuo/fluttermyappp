class PortfolioImage {
  final String imageUrl;
  final String uploaderId;

  PortfolioImage({required this.imageUrl, required this.uploaderId});

  factory PortfolioImage.fromMap(Map<String, dynamic> data) {
    return PortfolioImage(
      imageUrl: data['imageUrl'] ?? '',
      uploaderId: data['uploaderId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'uploaderId': uploaderId,
    };
  }
}
