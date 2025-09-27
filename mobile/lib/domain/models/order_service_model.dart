// lib/domain/models/order_service_model.dart

import 'user_model.dart';
import 'stock_model.dart';

class OrderServiceModel {
  final int id;
  final String tipo;
  final String setor;
  final DateTime data;
  final String recorrencia;
  final String? detalhes;
  final String status;
  final StockModel? equipamento;
  final UserModel solicitante;

  OrderServiceModel({
    required this.id,
    required this.tipo,
    required this.setor,
    required this.data,
    required this.recorrencia,
    this.detalhes,
    required this.status,
    this.equipamento,
    required this.solicitante,
  });

  factory OrderServiceModel.fromJson(Map<String, dynamic> json) {
    return OrderServiceModel(
      id: json['id'] as int,
      tipo: json['tipo'] as String,
      setor: json['setor'] as String,
      data: DateTime.parse(json['data'] as String),
      recorrencia: json['recorrencia'] as String,
      detalhes: json['detalhes'] as String?,
      status: json['status'] as String,
      equipamento: json['equipamento'] != null
          ? StockModel.fromJson(json['equipamento'])
          : null,
      solicitante: UserModel.fromJson(json['solicitante']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo,
      'setor': setor,
      'data': data.toIso8601String(),
      'recorrencia': recorrencia,
      'detalhes': detalhes,
      'status': status,
      'equipamento_id': equipamento?.id, // Envia apenas o ID
      'solicitante_id': solicitante.id, // Envia apenas o ID
    };
  }
}
