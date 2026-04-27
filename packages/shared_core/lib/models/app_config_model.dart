class AppConfigModel {
  final String currency;
  final String currencySymbol;
  final double deliveryDistanceLimit;
  final bool isMaintenance;
  final String? googleMapsApiKey;

  AppConfigModel({
    required this.currency,
    required this.currencySymbol,
    required this.deliveryDistanceLimit,
    required this.isMaintenance,
    this.googleMapsApiKey,
  });

  factory AppConfigModel.fromMap(Map<String, dynamic> map) {
    return AppConfigModel(
      currency: map['currency'] ?? 'BRL',
      currencySymbol: map['currencySymbol'] ?? 'R$',
      deliveryDistanceLimit: (map['deliveryDistanceLimit'] ?? 10.0).toDouble(),
      isMaintenance: map['isMaintenance'] ?? false,
      googleMapsApiKey: map['googleMapsApiKey'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currency': currency,
      'currencySymbol': currencySymbol,
      'deliveryDistanceLimit': deliveryDistanceLimit,
      'isMaintenance': isMaintenance,
      'googleMapsApiKey': googleMapsApiKey,
    };
  }
}
