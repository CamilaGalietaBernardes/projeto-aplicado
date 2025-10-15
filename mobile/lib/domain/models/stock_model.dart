// lib/domain/models/stock_model.dart

class StockModel {
  final int id;
  final String peca;
  final String categoria;
  final int qtd;
  final int qtdMin;

  StockModel({
    required this.id,
    required this.peca,
    required this.categoria,
    required this.qtd,
    required this.qtdMin,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      id: json['id'] as int,
      peca: json['peca'] as String,
      categoria: json['categoria'] as String,
      qtd: json['qtd'] as int,
      qtdMin: json['qtd_min'] as int,
    );
  }
}
