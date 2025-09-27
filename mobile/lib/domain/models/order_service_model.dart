// lib/domain/models/order_service_model.dart

import 'user_model.dart';
import 'stock_model.dart';

class OrderServiceModel {
  final int id;
  final String? tipo;
  final String? setor;
  final DateTime? data;
  final String? recorrencia;
  final String? detalhes;
  final String? status;
  final StockModel? equipamento;
  final UserModel? solicitante;

  OrderServiceModel({
    required this.id,
    this.tipo,
    this.setor,
    this.data,
    this.recorrencia,
    this.detalhes,
    this.status,
    this.equipamento,
    this.solicitante,
  });

  factory OrderServiceModel.fromJson(Map<String, dynamic> json) {
    return OrderServiceModel(
      // Campos obrigatórios. Se não existirem, lançam um erro, o que é o comportamento esperado.
      id: json['id'] as int,

      // Campos que podem ser null. Usamos a verificação explícita.
      tipo: json['tipo'] as String?,
      setor: json['setor'] as String?,
      detalhes: json['detalhes'] as String?,
      status: json['status'] as String?,
      recorrencia: json['recorrencia'] as String?,

      // Tratamento especial para o tipo DateTime, que pode falhar se a string for null.
      data: (json['data'] != null) ? DateTime.parse(json['data']) : null,

      // Tratamento para objetos aninhados que podem ser null.
      equipamento: (json['equipamento'] != null)
          ? StockModel.fromJson(json['equipamento'])
          : null,
      solicitante: (json['solicitante'] != null)
          ? UserModel.fromJson(json['solicitante'])
          : null,
    );
  }
}
