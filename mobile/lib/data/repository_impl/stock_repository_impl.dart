// lib/data/repository_impl/stock_repository_impl.dart

import 'package:mobile/data/services/stock_api.dart';
import 'package:mobile/domain/models/stock_model.dart';
import 'package:mobile/domain/repository/stock_repository.dart';

/// Implementação concreta do StockRepository
/// Delega as chamadas para o StockApiService
class StockRepositoryImpl implements StockRepository {
  final StockApiService apiService;

  StockRepositoryImpl(this.apiService);

  @override
  Future<List<StockModel>> fetchParts() async {
    return await apiService.fetchParts();
  }

  @override
  Future<StockModel> createPart(Map<String, dynamic> data) async {
    return await apiService.createPart(data);
  }

  @override
  Future<void> updatePart(int id, Map<String, dynamic> data) async {
    await apiService.updatePart(id, data);
  }

  @override
  Future<void> deletePart(int id) async {
    await apiService.deletePart(id);
  }

  @override
  Future<List<StockModel>> fetchLowStockAlerts() async {
    return await apiService.fetchLowStockAlerts();
  }
}
