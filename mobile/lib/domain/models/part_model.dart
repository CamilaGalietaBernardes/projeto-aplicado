class PartModel {
  final int id;
  final String nome;
  final String categoria;

  PartModel({required this.id, required this.nome, required this.categoria});

  factory PartModel.fromJson(Map<String, dynamic> json) {
    return PartModel(
      id: json['id'] as int,
      nome: json['nome'] as String,
      categoria: json['categoria'] as String,
    );
  }
}
