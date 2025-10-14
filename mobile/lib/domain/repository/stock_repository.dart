// lib/domain/repository/stock_repository.dart

import 'package:mobile/domain/models/stock_model.dart';

/// Interface que define as operações de estoque
/// Seguindo o padrão Repository para desacoplar a lógica de negócio da camada de dados
abstract class StockRepository {
  /// Busca todas as peças do estoque
  Future<List<StockModel>> fetchParts();

  /// Cria uma nova peça no estoque
  ///
  /// [data] deve conter:
  /// - nome: String
  /// - categoria: String
  /// - qtd: int
  /// - qtd_min: int
  Future<StockModel> createPart(Map<String, dynamic> data);

  /// Atualiza uma peça existente
  ///
  /// [id] - ID da peça a ser atualizada
  /// [data] - Campos a serem atualizados
  Future<void> updatePart(int id, Map<String, dynamic> data);

  /// Exclui uma peça do estoque
  ///
  /// [id] - ID da peça a ser excluída
  Future<void> deletePart(int id);

  /// Busca peças com estoque abaixo do mínimo (alertas)
  Future<List<StockModel>> fetchLowStockAlerts();
}
